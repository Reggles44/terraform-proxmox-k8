output "ip" {
  value = proxmox_vm_qemu.k8_node.*.ssh_host
}

