terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://${var.proxmox_host}/api2/json"
  pm_api_token_id     = var.proxmox_api_user
  pm_api_token_secret = var.proxmox_api_token
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "k8-admin" {
  name        = "k8-admin"
  desc        = "k8 admin node"
  vmid        = 1000
  target_node = "pve"
  count       = 1
  clone       = "debian-12-template"
  bootdisk    = "scsi0"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  cpu         = "host"
  memory      = 4096
  vm_state    = "running"
  onboot      = true

  disk {
    slot    = "scsi0"
    size    = "16G"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "192.168.10.110"

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipconfig0},' docker-install.yml"
  }

}

resource "proxmox_vm_qemu" "k8-node" {
  count       = 1
  name        = "k8-node-${count.index + 1}"
  vmid        = 1000 + count.index + 1
  target_node = "pve"
  clone       = "debian-12"
  bootdisk    = "scsi0"
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  cpu         = "host"
  memory      = 4096
  vm_state    = "running"
  onboot      = true


  disk {
    slot    = "scsi0"
    size    = "16G"
    storage = "local-lvm"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "192.168.10.1${count.index + 11}"

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipconfig0},' docker-install.yml"
  }

  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' kubernetes-install.yml"
  # }

}

