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

### Kubernetes Cluster Settings
variable "talos_iso" {
  description = "Path to Talos ISO (e.g., storage-pool:iso/filename.iso)"
  type        = string
}

variable "kube_node_storage_pool" {
  description = "Storage pool to use for VM disks (e.g., nas-vdisk)"
  type        = string
}

variable "control_plane_count" {
  description = "Number of control plane nodes to deploy"
  type        = number
}

variable "worker_count" {
  description = "Number of worker nodes to deploy"
  type        = number
}

variable "master_target_nodes" {
  description = "List of Proxmox nodes to cycle through for control planes"
  type        = list(string)
}

variable "worker_target_nodes" {
  description = "List of Proxmox nodes to cycle through for workers"
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
