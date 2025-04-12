output "name" {
  value = proxmox_vm_qemu.vm.name
}

output "ip_address" {
  value = proxmox_vm_qemu.vm.default_ipv4_address
}