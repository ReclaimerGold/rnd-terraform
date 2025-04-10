### PVE (Proxmox Virtual Environment)
variable "proxmox_api_url" {
  description = "Proxmox URL"
  type        = string
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
}

variable "pm_tls_insecure" {
  description = "Proxmox TLS Insecure (Bypass Self-Signed)"
  type        = bool
}

### k8s (Kubernetes Cluster) Cluster
variable "talos_iso" {
  description = "Talos ISO Location/Name (storage-pool/iso-file-name)"
  type        = string
}
variable "kube_node_storage_pool" {
  description = "nas-vdisk"
  type        = string
}

# Master Nodes
variable "kube_master_ram" {
  description = "k8s Master Node Memory Limit"
  type        = number
}

variable "kube_master_balloon" {
  description = "k8s Master Node Memory Balloon Minimum"
  type        = number
}

variable "kube_master_cpus" {
  description = "k8s Master Node vCPU Allocation"
  type        = number
}

variable "kube_master_storage" {
  description = "k8s Master Node Root Disk Size"
  type        = string
}

# Worker Nodes
variable "kube_worker_ram" {
  description = "k8s Worker Node Memory Limit"
  type        = number
}

variable "kube_worker_balloon" {
  description = "k8s Worker Node Memory Balloon Minimum"
  type        = number
}

variable "kube_worker_cpus" {
  description = "k8s Worker Node vCPU Allocation"
  type        = number
}

variable "kube_worker_storage" {
  description = "k8s Worker Node Root Disk Size"
  type        = string
}