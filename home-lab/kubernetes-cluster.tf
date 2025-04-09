### Virtual Machines

# Control Plane 01
resource "proxmox_vm_qemu" "talos-m01" {
  name        = "talos-m01"
  target_node = "vm-01"
  agent       = 1
  memory      = 4096
  balloon     = 2048
  # sockets         = 1
  cores = 4
  tags  = "kubernetes,kcp"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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
  memory      = 4096
  balloon     = 2048
  # sockets         = 1
  cores = 4
  tags  = "kubernetes,kcp"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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
  memory      = 4096
  balloon     = 2048
  # sockets         = 1
  cores = 4
  tags  = "kubernetes,kcp"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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
  memory      = 2048
  balloon     = 2048
  # sockets         = 1
  cores = 2
  tags  = "kubernetes,kw"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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
  memory      = 2048
  balloon     = 2048
  # sockets         = 1
  cores = 2
  tags  = "kubernetes,kw"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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
  memory      = 2048
  balloon     = 2048
  # sockets         = 1
  cores = 2
  tags  = "kubernetes,kw"

  disks {
    scsi {
      scsi0 {
        disk { # Root Disk
          size    = "20G"
          storage = "nas-vdisk"
        }
      }
      scsi1 {
        disk { # Storage Disk
          size    = "100G"
          storage = "nas-vdisk"
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = "nas-isos:iso/talos-metal-amd64.iso"
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