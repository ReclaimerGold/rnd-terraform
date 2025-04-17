### Local Variables (kubernetes-cluster.tf only)
locals {
  ### Dynamic IP Addresses - Retrieved from PVE QEMU Agent
  master_ips   = [for m in module.control_plane : m.ip_address]
  worker_ips   = [for m in module.worker : m.ip_address]

  ### Aggregated Lists
  master_names   = [for m in module.control_plane : m.name]
  worker_names   = [for m in module.worker : m.name]
  master_domains = [for name in local.master_names : "${name}.${var.dns_cluster_sld}.${var.dns_base_tld}"]
  worker_domains = [for name in local.worker_names : "${name}.${var.dns_cluster_sld}.${var.dns_base_tld}"]

  all_node_names = concat(local.master_names, local.worker_names)
  all_node_ips = concat(local.master_ips, local.worker_ips)
  all_node_static_ips = concat(var.master_target_ips, var.worker_target_ips)
  all_node_domains = concat(local.master_domains, local.worker_domains)
  
  # Name => *Static* IP Address Map
  node_map_static = merge(
    { for idx, name in local.master_names : name => var.master_target_ips[idx] },
    { for idx, name in local.worker_names : name => var.worker_target_ips[idx] },
  )

  # Name => *Dynamic* (current/DHCP) IP Address Map
  node_map_dynamic = merge(
    { for m in module.control_plane : m.name => m.ip_address },
    { for m in module.worker        : m.name => m.ip_address }
  )

  # Utilized to generate the endpoints list in the talosconfig
  formatted_endpoint_urls = [
    for ip in var.master_target_ips : "https://${ip}:6443"
  ]

  ### Master URL for Initial Bootstrap (Currentl picks first CP in list)
  master_url   = "https://${local.master_domains[0]}:6443"

  ### Determines Counts of Node Types for Looping Module Blocks
  control_plane_count = length(var.master_target_ips) # Dynamically Set Loop Iteration for CPs to IP Count
  worker_count = length(var.worker_target_ips)        # Dynamically Set Loop Iteration for Ws to IP Count

  cluster_name     = "${var.dns_cluster_sld}.${var.dns_base_tld}"
}

### Node Infrastructure (VMs on PVE)
module "control_plane" {
  source = "./modules/vm"
  count  = local.control_plane_count

  providers = {
    proxmox = proxmox
  }

  name_prefix  = "talos-m"
  index        = count.index
  memory       = var.kube_master_ram
  balloon      = var.kube_master_balloon
  cores        = var.kube_master_cpus
  tags         = "kubernetes,kcp"
  pool         = var.pm_pool
  scsihw       = "virtio-scsi-single"
  disk_size    = var.kube_master_storage
  storage_pool = var.kube_node_storage_pool
  iso          = var.talos_iso
  bridge       = "vmbr0"
  vlan_tag     = var.datacenter_vlan_tag
  target_nodes = var.master_target_nodes
}

module "worker" {
  source = "./modules/vm"
  count  = local.worker_count
  depends_on = [ module.control_plane ]

  providers = {
    proxmox = proxmox
  }

  name_prefix  = "talos-w"
  index        = count.index
  memory       = var.kube_worker_ram
  balloon      = var.kube_worker_balloon
  cores        = var.kube_worker_cpus
  tags         = "kubernetes,kw"
  pool         = var.pm_pool
  scsihw       = "virtio-scsi-single"
  disk_size    = var.kube_worker_storage
  storage_pool = var.kube_node_storage_pool
  iso          = var.talos_iso
  bridge       = "vmbr0"
  vlan_tag     = var.datacenter_vlan_tag
  target_nodes = var.worker_target_nodes
}

### AdGuard DNS Record Setup
resource "adguard_rewrite" "kubernetes_nodes" {
  for_each = local.node_map_static

  domain = "${each.key}.${var.dns_cluster_sld}.${var.dns_base_tld}"
  answer = each.value
}

### Node OS Configuration (Talos)

# Generate Machine Secrets for Talos Cluster
resource "talos_machine_secrets" "machine_secrets" {}

# Declare Node Configuration
data "talos_machine_configuration" "node_config" {
  for_each         = local.node_map_dynamic
  depends_on = [ 
      talos_machine_secrets.machine_secrets,
      module.control_plane,
      module.worker
    ]

  cluster_name     = local.cluster_name
  cluster_endpoint = "https://${local.node_map_static[local.master_names[0]]}:6443"
  machine_type     = contains(local.master_names, each.key) ? "controlplane" : "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets

  config_patches = compact([
    yamlencode({
      machine = {
        install = {
          image = "factory.talos.dev/installer/88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b:v1.9.5"
          # Pre-Built Image to include 'iscsi-tools', 'qemu-guest-agent', and 'util-linux-tools'
        }
        kubelet = {
          extraMounts = [
            {
              destination = "/var/lib/longhorn"  # Longhorn data path
              type        = "bind"
              source      = "/var/lib/longhorn"
              options     = ["bind","rshared","rw"]
            }
          ]
        }
        # If you ever move to V2 Data Engine, you can also uncomment:
        # sysctls = { "vm.nr_hugepages" = "1024" }
        # kernel  = { modules = [{ name = "nvme_tcp" }, { name = "vfio_pci" }] }
        # ——— END Longhorn Talos Linux Support ———
        network = {
          #nameservers = [var.dns_server_01, var.dns_server_02]
          hostname = "${each.key}"
          interfaces = [
            {
              interface = "ens18"
              addresses = ["${local.node_map_static[each.key]}/24"]
              routes = [
                {
                  network = "0.0.0.0/0"
                  gateway = var.node_gateway_ip
                  metric  = 1024
                }
              ]
            }
          ]
        }
      }
    })
  ])
}

# Generate Client Configuration
data "talos_client_configuration" "client_config" {
  depends_on = [ talos_machine_secrets.machine_secrets ]
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = var.master_target_ips
  nodes                = local.all_node_static_ips
}

# Applies configuration for master nodes
resource "talos_machine_configuration_apply" "node_config_apply" {
  for_each = local.node_map_dynamic

  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.node_config[each.key].machine_configuration
  node                        = each.value
}

# Bootstraps the Talos Cluster
resource "talos_machine_bootstrap" "node_bootstrap" {
  depends_on = [ talos_machine_configuration_apply.node_config_apply ]

  node                 = local.node_map_static[local.master_names[0]]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
}

# Retrieve Kubeconfig for Kubernetes
resource "talos_cluster_kubeconfig" "cluster_kubeconfig" {
  depends_on          = [ talos_machine_bootstrap.node_bootstrap ]
  node                  = local.node_map_static[local.master_names[0]]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
}

### Outputs

# Retrieve Kubeconfig
output "o_kubeconfig" {
  value       = talos_cluster_kubeconfig.cluster_kubeconfig.kubeconfig_raw
  description = "The Kubeconfig for the Kubernetes cluster."
  sensitive   = true
}

output "o_talosconfig" {
  value       = data.talos_client_configuration.client_config.talos_config
  description = "The talosconfig for the Talos cluster"
  sensitive   = true
}

output "o_cluster_name" {
  value       = local.cluster_name
  description = "The name of the cluster for the talosconfig"
}