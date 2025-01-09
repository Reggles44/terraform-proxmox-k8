variable "proxmox_host" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "proxmox_user" {
  type = string
}

variable "vmid" {
  type = number
}

variable "ip_address" {
  type = string
}

variable "gateway" {
  type = string
}

