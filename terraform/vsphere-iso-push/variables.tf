##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.example.com)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The name of the vSphere datacenter. (e.g. sfo-m01-dc01)"
}

variable "push_type" {
  type        = string
  description = "Destination type for ISO upload. Accepted values: \"datastore\" or \"content_library\"."
  default     = "datastore"

  validation {
    condition     = contains(["datastore", "content_library"], var.push_type)
    error_message = "push_type must be either \"datastore\" or \"content_library\"."
  }
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the vSphere datastore to upload the ISO files to. Required when push_type is \"datastore\". (e.g. sfo-m01-cl01-ds-vsan01)"
  default     = null
}

variable "vsphere_datastore_path" {
  type        = string
  description = "The remote directory path on the datastore where ISO files will be uploaded. Used when push_type is \"datastore\". (e.g. iso)"
  default     = "iso"
}

variable "vsphere_content_library" {
  type        = string
  description = "The name of the vSphere Content Library to upload the ISO files to. Required when push_type is \"content_library\". (e.g. sfo-m01-lib01)"
  default     = null
}

# ISO Upload Settings

variable "iso_base_path" {
  type        = string
  description = "The local base path containing the ISO directories to upload. (e.g. ../../iso)"
  default     = "../../iso"
}
