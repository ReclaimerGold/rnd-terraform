### Datacenter Network Configuration
variable "datacenter_vlan_tag" {
  description = "Specifies the VLAN tag that should be used when deploying machines to the datacenter."
}

### Local DNS
variable "dns_base_tld" {
  description = "The base TLD (Top-Level Domain) for your local network. Example: 'microsoft.com' would be 'com'."
  type        = string
}

variable "dns_cluster_sld" {
  description = "The SLD (Second-Level Domain) for your Kubernetes Cluster. Example: 'microsoft.com' would be 'microsoft'."
  type        = string
}

### Adguard DNS Server
variable "adguard_host" {
  description = "The Username for the Terraform Account in AdGuard"
  type        = string
}

variable "adguard_username" {
  description = "The Password for the Terraform Account in AdGuard"
  type        = string
}

variable "adguard_password" {
  description = "The URL for the AdGuard server"
  type        = string
}

### PVE (Proxmox Virtual Environment)
variable "proxmox_api_url" {
  description = "Proxmox API URL (e.g., https://your-proxmox-host:8006/api2/json)"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID (e.g., terraform@pve!token-name)"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set to true to bypass self-signed TLS cert validation"
  type        = bool
  default     = false
}

variable "pm_pool" {
  description = "Proxmox Pool to Deploy Resources Into"
  type        = string
}

### Kubernetes Cluster Settings
variable "talos_iso" {
  description = "Path to Talos ISO (e.g., storage-pool:iso/filename.iso)"
  type        = string
}

variable "kube_node_storage_pool" {
  description = "Storage pool to use for VM disks (e.g., nas-vdisk)"
  type        = string
}

variable "master_target_nodes" {
  description = "List of Proxmox nodes to cycle through for control planes"
  type        = list(string)
}

variable "worker_target_nodes" {
  description = "List of Proxmox nodes to cycle through for workers"
  type        = list(string)
}

variable "node_gateway_ip" {
  description = "Specifies the Gateway IP addresses to use when deploying nodes."
  type        = string
}

variable "master_target_ips" {
  description = "Specifies the IP addresses to use when deploying control plane nodes."
  type        = list(string)
}

variable "worker_target_ips" {
  description = "Specifies the IP addresses to use when deploying worker nodes."
  type        = list(string)
}

### Control Plane Node Configuration
variable "kube_master_ram" {
  description = "RAM for each control plane node (in MB)"
  type        = number
}

variable "kube_master_balloon" {
  description = "Balloon memory minimum for control plane"
  type        = number
}

variable "kube_master_cpus" {
  description = "vCPU count for each control plane node"
  type        = number
}

variable "kube_master_storage" {
  description = "Disk size for each control plane (e.g., '100G')"
  type        = string
}

### Worker Node Configuration
variable "kube_worker_ram" {
  description = "RAM for each worker node (in MB)"
  type        = number
}

variable "kube_worker_balloon" {
  description = "Balloon memory minimum for worker node"
  type        = number
}

variable "kube_worker_cpus" {
  description = "vCPU count for each worker node"
  type        = number
}

variable "kube_worker_storage" {
  description = "Disk size for each worker node (e.g., '100G')"
  type        = string
}
