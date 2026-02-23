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
    is_system   = false
  }
}

# a newly created Cloud Director vDC associated to the Org
resource "vcd_org_vdc" "brand_new_vdc" {
  name        = var.customer_datacenter_name
  org         = vcd_org.brand_new_org.name

  allocation_model  = "Flex"
  network_pool_name = var.vcd_network_pool      # Change to your actual Network Pool name
  provider_vdc_name = var.vcd_provider    # Change to your actual pVDC name

  compute_capacity {
    cpu {
      allocated = 2000 # MHz
      limit = 2000
    }
    memory {
      allocated = 4096 # MB
      limit = 4096
    }
  }

  storage_profile {
    name    = var.customer_datacenter_storage_profile       # Change to your actual Storage Profile
    limit   = 10240                    # MB
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