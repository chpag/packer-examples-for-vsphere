
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

variable "vsphere_folder" {
  type        = string
  description = "The name of the vSphere folder to place the virtual machine in."
}

variable "vsphere_template_folder" {
  type        = string
  description = "The name of the vSphere folder to search for templates."
}

variable "vsphere_content_library" {
  type        = string
  description = "The name of the vSphere Content Library."
}

variable "is_contentlib_template" {
  type        = bool
  description = "Is Template located in Content Library"
  default     = false
}

variable "vsphere_network" {
  type        = string
  description = "The name of the vSphere network to attach the virtual machine to."
}

variable "vsphere_template" {
  type        = string
  description = "The name of the Packer-built RHEL template in the vSphere inventory."
}

# Virtual Machine Settings

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine."
}

variable "vm_cpus" {
  type        = number
  default     = 2
  description = "The number of virtual CPUs."
}

variable "vm_memory" {
  type        = number
  default     = 4096
  description = "The amount of memory (MB) for the virtual machine."
}

variable "vm_firmware" {
  type        = string
  default     = "efi"
  description = "The firmware type for the virtual machine. (efi or bios)"
}

variable "vm_efi_secure_boot_enabled" {
  type        = bool
  default     = true
  description = "Enable EFI Secure Boot for the virtual machine."
}

variable "vm_hostname" {
  type        = string
  description = "The hostname for the RHEL virtual machine."
}

variable "vm_domain" {
  type        = string
  description = "The domain name for the RHEL virtual machine."
}

variable "vm_ipv4_address" {
  type        = string
  description = "The static IPv4 address for the virtual machine."
}

variable "vm_ipv4_netmask" {
  type        = string
  description = "The IPv4 netmask (prefix length) for the virtual machine (e.g. 24)."
}

variable "vm_ipv4_gateway" {
  type        = string
  description = "The IPv4 default gateway for the virtual machine."
}

variable "vm_dns_suffix_list" {
  type        = list(string)
  description = "A list of DNS search domains for the virtual machine."
}

variable "vm_dns_server_list" {
  type        = list(string)
  description = "A list of DNS server addresses for the virtual machine."
}
