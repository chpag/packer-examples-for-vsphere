# STEP 2 — item deleted in vCenter + removed from state
# Replace the library_id value below with the one from your tfstate
# Run: terraform apply -var num_cpus=4
# Expected: CPU change applies. Observed: ERROR

resource "vsphere_content_library" "lib" {
  name            = "repro-library"
  storage_backing = [data.vsphere_datastore.ds.id]
}

# ⚠️ vsphere_content_library_item resource removed — item was deleted outside Terraform
# The data source below now points to a non-existent item

data "vsphere_content_library_items" "template" {
  library_id = vsphere_content_library.lib.id
  name       = "TinyVM"
}

locals {
  template_id = length(data.vsphere_content_library_items.template.items) > 0 ? data.vsphere_content_library_items.template.items[0].id : null
}

resource "vsphere_virtual_machine" "web" {
  name             = "repro-vm-01"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  num_cpus         = 4   # ← only change we want to apply
  memory           = 1024
  guest_id         = "other3xLinuxGuest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
  }

  dynamic "clone" {
    for_each = local.template_id != null ? [1] : []
    content {
      template_uuid = local.template_id
    }
  }
  lifecycle {
    ignore_changes = [clone]
  }
}
