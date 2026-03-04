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
  
  vapp_lease {
    maximum_runtime_lease_in_sec = 0
    delete_on_storage_lease_expiration = false
    maximum_storage_lease_in_sec = 0
    power_off_on_runtime_lease_expiration = false
  }
  vapp_template_lease {
    maximum_storage_lease_in_sec = 0
    delete_on_storage_lease_expiration = false
  }

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
  depends_on = [ vcd_org.brand_new_org ]

  enabled = true
  allocation_model  = "Flex"
  network_pool_name = var.vcd_network_pool      # Change to your actual Network Pool name
  provider_vdc_name = var.vcd_provider    # Change to your actual pVDC name
  elasticity = false
  include_vm_memory_overhead = false
  memory_guaranteed = 0.1
  cpu_guaranteed = 0
  cpu_speed = var.customer_datacenter_cpu_speed
  vm_quota = 0
  network_quota = 10
  enable_thin_provisioning = true
  enable_fast_provisioning = false

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

}

resource "vcd_org_user" "org_admin" {
  depends_on = [ random_password.org_user_password ]
  org         = vcd_org.brand_new_org.name
  name        = var.customer_organization_user
  password    = random_password.org_user_password.result
  role        = "Organization Administrator"
  enabled     = true

  # Forces password change on first login
  take_ownership = true
}