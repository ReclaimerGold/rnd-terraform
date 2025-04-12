terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

# Virtual Machine Skeleton
resource "proxmox_vm_qemu" "vm" {
  name        = "${var.name_prefix}${format("%02d", var.index + 1)}"
  target_node = element(var.target_nodes, var.index)
  agent       = 1
  skip_ipv6   = true # Acquiring an IPv6 address from the qemu guest agent isn't required
  memory      = var.memory
  balloon     = var.balloon
  cores       = var.cores
  tags        = var.tags
  pool        = var.pool
  scsihw      = var.scsihw

  disks {
    scsi {
      scsi0 {
        disk {
          size     = var.disk_size
          storage  = var.storage_pool
          format   = "qcow2"
          iothread = true
        }
      }
    }
    ide {
      ide2 {
        cdrom {
          iso = var.iso
        }
      }
    }
  }

  network {
    id       = 0
    model    = "virtio"
    bridge   = var.bridge
    firewall = true
    tag      = var.vlan_tag
  }
}
