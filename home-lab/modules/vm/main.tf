terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

# Mac Address Generation
resource "random_id" "mac" {
  byte_length = 3
  keepers = {
    vm_name = "${var.name_prefix}${format("%02d", var.index + 1)}"
  }
}

# Virtual Machine Skeleton
resource "proxmox_vm_qemu" "vm" {
  name        = "${var.name_prefix}${format("%02d", var.index + 1)}"
  target_node = element(var.target_nodes, var.index)
  agent       = 0
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

    # Utilized to generate a static MAC address for the lifetime of the machine to maintain IP address reservations when Talos Nodes reboot to configure
    macaddr = format(
      "52:54:00:%s:%s:%s",
      substr(random_id.mac.hex, 0, 2),
      substr(random_id.mac.hex, 2, 2),
      substr(random_id.mac.hex, 4, 2)
    )
  }
}

output "mac_address" {
  value = format(
    "52:54:00:%s:%s:%s",
    substr(random_id.mac.hex, 0, 2),
    substr(random_id.mac.hex, 2, 2),
    substr(random_id.mac.hex, 4, 2)
  )
}