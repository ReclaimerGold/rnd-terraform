terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}

# Providers
provider "proxmox" {
  pm_api_url      = "https://192.168.1.120:8006/api2/json"
  pm_api_token_id = "terraform-prov@pve!terraform-prov"
  pm_debug        = true
  pm_tls_insecure = true
}