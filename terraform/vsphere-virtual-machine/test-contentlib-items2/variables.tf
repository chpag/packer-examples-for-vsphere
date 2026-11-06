variable "vsphere_server" {
  type        = string
  description = "The FQDN or IP address of the vCenter Server instance."
}

variable "vsphere_username" {
  type        = string
  sensitive   = true
  description = "The username to authenticate to the vCenter Server instance."
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "The password to authenticate to the vCenter Server instance."
}

variable "vsphere_datacenter" {
  type        = string
  description = "The name of the vSphere datacenter."
}

variable "vsphere_cluster" {
  type        = string
  description = "The name of the vSphere cluster."
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the vSphere datastore."
}

variable "vsphere_content_library" {
  type        = string
  description = "The name of the vSphere Content Library."
}

variable "vsphere_network" { 
  type        = string
  description = "The name of the vSphere network to attach the virtual machine to."
} 
