### Virtual Machines

# Control Plane 01
resource "proxmox_vm_qemu" "talos-m01" {
  name        = "talos-m01"
  target_node = "vm-01"
  agent       = 1
  memory      = var.kube_master_ram
  balloon     = var.kube_master_balloon
  # sockets         = 1
  cores = var.kube_master_cpus
  tags  = "kubernetes,kcp"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_master_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_master_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

# Control Plane 02
resource "proxmox_vm_qemu" "talos-m02" {
  name        = "talos-m02"
  target_node = "vm-01" # Set to 'vm-01' while 'vm-02' is in hibernation
  agent       = 1
  memory      = var.kube_master_ram
  balloon     = var.kube_master_balloon
  # sockets         = 1
  cores = var.kube_master_cpus
  tags  = "kubernetes,kcp"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_master_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_master_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

# Control Plane 03
resource "proxmox_vm_qemu" "talos-m03" {
  name        = "talos-m03"
  target_node = "vm-03"
  agent       = 1
  memory      = var.kube_master_ram
  balloon     = var.kube_master_balloon
  # sockets         = 1
  cores = var.kube_master_cpus
  tags  = "kubernetes,kcp"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_master_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_master_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

# Worker 01
resource "proxmox_vm_qemu" "talos-w01" {
  name        = "talos-w01"
  target_node = "vm-01"
  agent       = 1
  memory      = var.kube_worker_ram
  balloon     = var.kube_worker_balloon
  # sockets         = 1
  cores = var.kube_worker_cpus
  tags  = "kubernetes,kw"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_worker_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_worker_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

# Worker 02
resource "proxmox_vm_qemu" "talos-w02" {
  name        = "talos-w02"
  target_node = "vm-01" # Set to 'vm-01' while 'vm-02' is in hibernation
  agent       = 1
  memory      = var.kube_worker_ram
  balloon     = var.kube_worker_balloon
  # sockets         = 1
  cores = var.kube_worker_cpus
  tags  = "kubernetes,kw"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_worker_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_worker_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

# Worker 03
resource "proxmox_vm_qemu" "talos-w03" {
  name        = "talos-w03"
  target_node = "vm-03"
  agent       = 1
  memory      = var.kube_worker_ram
  balloon     = var.kube_worker_balloon
  # sockets         = 1
  cores = var.kube_worker_cpus
  tags  = "kubernetes,kw"
  pool = "reifnet"
  scsihw = "virtio-scsi-single"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = var.kube_worker_storage_root
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = var.kube_worker_storage_cluster
          storage = var.kube_node_storage_pool
          format  = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.talos_iso
        }
      }
    }
  }

  network { # Primary Interface
    id       = 0
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = true
  }
}

### LXC Containers
# TODO: Add in container registration for cluster proxy system. Ideally want to use HA Proxy to allow for future expansion of proxy services in cluster mode.

### HA Proxy Configuration
# TODO: Utlilize provider listed below to create HA Proxy configuration for above LXC Declaration for HA Proxy
# https://registry.terraform.io/providers/SepehrImanian/haproxy/latest/docs
