output "name" {
  value = proxmox_vm_qemu.vm.name
}

output "ip_address" {
  value = proxmox_vm_qemu.vm.default_ipv4_address
}

output "mac_address" {
  value = format(
    "52:54:00:%s:%s:%s",
    substr(random_id.mac.hex, 0, 2),
    substr(random_id.mac.hex, 2, 2),
    substr(random_id.mac.hex, 4, 2)
  )
}