##################################################################################
# PROVIDERS
##################################################################################

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA SOURCES
##################################################################################

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

# Used only when push_type == "datastore"
data "vsphere_datastore" "datastore" {
  count         = var.push_type == "datastore" ? 1 : 0
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# Used only when push_type == "content_library"
data "vsphere_content_library" "library" {
  count = var.push_type == "content_library" ? 1 : 0
  name  = var.vsphere_content_library
}

##################################################################################
# LOCALS
##################################################################################

locals {
  # Recursively discover all .iso files under var.iso_base_path.
  # The fileset path is relative to the Terraform working directory, so the
  # caller must ensure that var.iso_base_path resolves correctly (e.g. use
  # the default "../../iso" when running from this module directory, or an
  # absolute path otherwise).
  iso_files = toset([
    for f in fileset(var.iso_base_path, "**/*.iso") : f
  ])
}

##################################################################################
# RESOURCES
##################################################################################

# --- Datastore upload -----------------------------------------------------------

resource "vsphere_file" "iso_upload" {
  for_each = var.push_type == "datastore" ? local.iso_files : toset([])

  # vSphere target
  datacenter       = var.vsphere_datacenter
  datastore        = var.vsphere_datastore
  destination_file = "${var.vsphere_datastore_path}/${each.value}"

  # Local source – combine the base path with the relative file path
  source_file        = "${var.iso_base_path}/${each.value}"
  create_directories = true
}

# --- Content Library upload -----------------------------------------------------

resource "vsphere_content_library_item" "iso_upload" {
  for_each = var.push_type == "content_library" ? local.iso_files : toset([])

  # Item name derived from the ISO filename (basename without extension)
  name        = replace(basename(each.value), ".iso", "")
  description = "ISO uploaded by Terraform from ${each.value}"
  library_id  = data.vsphere_content_library.library[0].id
  type        = "iso"

  # Local source
  file_url = "${var.iso_base_path}/${each.value}"
}

##################################################################################
# OUTPUTS
##################################################################################

output "uploaded_iso_files" {
  description = "Map of local ISO file paths to their upload destinations."
  value = var.push_type == "datastore" ? (
    {
      for k, v in vsphere_file.iso_upload :
      k => v.destination_file
    }
    ) : (
    {
      for k, v in vsphere_content_library_item.iso_upload :
      k => "content-library://${var.vsphere_content_library}/${v.name}/${basename(k)}"
    }
  )
}
