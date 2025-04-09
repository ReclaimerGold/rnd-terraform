resource "proxmox_vm_qemu" "talos-m01" {
    name            = "talos-m01"
    target_node     = "vm-01"
    agent           = 1
    memory          = 4096
    balloon         = 2048
    # sockets         = 1
    cores           = 4
    tags            = "kubernetes,kcp"
    iso             = "nas-isos:iso/talos-metal-amd64.iso"

    disk { # Root Disk
        type        = "scsi"
        slot        = 0
        size        = "20G"
        storage     = "nas-vdisk"
    }

    disk { # Storage Disk
        type        = "scsi"
        slot        = 1
        size        = "100G"
        storage     = "nas-vdisk"
    }

    disk { # Storage Disk
        type        = "cdrom"
        slot        = 2
        iso         = "nas-isos:iso/talos-metal-amd64.iso"
        storage = "nas-isos"
    }

    network { # Primary Interface
        model       = "virtio"
        bridge      = "vmbr0"
        firewall    = true
    }
}