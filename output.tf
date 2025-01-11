output "k8_node_ips" {
  value = proxmox_vm_qemu.k8_node.*.ssh_host
}

