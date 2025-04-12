terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc8"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
    adguard = {
      source  = "gmichels/adguard"
      version = "1.5.1"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure
}

provider "talos" {}

provider "adguard" {
  host     = var.adguard_host
  username = var.adguard_username
  password = var.adguard_password
  scheme   = "http" # defaults to https
  timeout  = 5      # in seconds, defaults to 10
  insecure = false  # when `true` will skip TLS validation
}