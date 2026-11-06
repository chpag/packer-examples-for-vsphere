##################################################################################
# VARIABLES
##################################################################################

# Credentials

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

variable "vsphere_insecure" {
  type        = bool
  default     = false
  description = "Allow insecure connections to the vCenter Server instance."
}

# vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "Vsphere Datacenter."
}
variable "vsphere_content_library" {
  type        = string
  description = "The name of the vSphere Content Library."
}

variable "tinyvm_url" {
  type        = string
  description = "URL for TinyVM OVA."
}
