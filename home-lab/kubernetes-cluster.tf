### Node Infrastructure (VMs on PVE)
module "control_plane" {
  source           = "./modules/vm"
  count            = var.control_plane_count

  providers = {
    proxmox = proxmox
  }

  name_prefix      = "talos-m"
  index            = count.index
  memory           = var.kube_master_ram
  balloon          = var.kube_master_balloon
  cores            = var.kube_master_cpus
  tags             = "kubernetes,kcp"
  pool             = "reifnet"
  scsihw           = "virtio-scsi-single"
  disk_size        = var.kube_master_storage
  storage_pool     = var.kube_node_storage_pool
  iso              = var.talos_iso
  bridge           = "vmbr0"
  vlan_tag         = 50
  target_nodes     = var.master_target_nodes
}

module "worker" {
  source           = "./modules/vm"
  count            = var.worker_count

  providers = {
    proxmox = proxmox
  }

  name_prefix      = "talos-w"
  index            = count.index
  memory           = var.kube_worker_ram
  balloon          = var.kube_worker_balloon
  cores            = var.kube_worker_cpus
  tags             = "kubernetes,kw"
  pool             = "reifnet"
  scsihw           = "virtio-scsi-single"
  disk_size        = var.kube_worker_storage
  storage_pool     = var.kube_node_storage_pool
  iso              = var.talos_iso
  bridge           = "vmbr0"
  vlan_tag         = 50
  target_nodes     = var.worker_target_nodes
}