# Configure the VMware Cloud Director Provider
provider "vcd" {
  user                 = var.vcd_system_user
  password             = var.vcd_system_password
  auth_type            = "integrated"
  org                  = "System"
  url                  = var.vcd_api_url
  max_retry_timeout    = 60
  allow_unverified_ssl = false 
}

resource "random_password" "org_user_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# a newly created Cloud Director Org
resource "vcd_org" "brand_new_org" {
  name             = var.customer_organization_name
  full_name        = var.customer_organization_fullname
  is_enabled       = true
  delete_recursive = true
  delete_force     = true

  deployed_vm_quota = 20
  can_publish_catalogs = true

  metadata_entry {
    key         = "email.techsupport"
    value       = var.customer_organization_techsupportemail
    type        = "MetadataStringValue"
    user_access = "READONLY"
    is_system   = true
  }
}

# a newly created Cloud Director vDC associated to the Org
resource "vcd_org_vdc" "brand_new_vdc" {
  name        = var.customer_datacenter_name
  org         = vcd_org.brand_new_org.name

  allocation_model  = "Flex"
  network_pool_name = var.vcd_network_pool      # Change to your actual Network Pool name
  provider_vdc_name = var.vcd_provider    # Change to your actual pVDC name
  elasticity = true
  include_vm_memory_overhead = true
  memory_guaranteed = 0.1

  compute_capacity {
    cpu {
      allocated = var.customer_datacenter_cpu_quota # MHz
      limit = var.customer_datacenter_cpu_quota
    }
    memory {
      allocated = var.customer_datacenter_memory_quota # MB
      limit = var.customer_datacenter_memory_quota
    }
  }

  storage_profile {
    name    = var.customer_datacenter_storage_profile       # Change to your actual Storage Profile
    limit   = var.customer_datacenter_storage_quota                    # MB
    default = true
  }

  enabled = true
}


resource "vcd_org_user" "org_admin" {
  org         = vcd_org.brand_new_org.name
  name        = var.customer_organization_user
  password    = random_password.org_user_password.result
  role        = "Organization Administrator"
  enabled     = true

  # Forces password change on first login
  take_ownership = true
}