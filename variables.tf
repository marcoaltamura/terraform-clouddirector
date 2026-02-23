# variables.tf

# CLOUD DIRECTOR VARIABLES

variable "vcd_system_user" {
  type        = string
  description = "Cloud Director System User"
}

variable "vcd_system_password" {
  type    = string
  description = "Cloud Director System Password"
}

variable "vcd_api_url" {
  type = string
  description = "Cloud Director API URL"
}

variable "vcd_network_pool" {
  type = string
  description = "Cloud Director Network Pool"
}

variable "vcd_provider" {
  type = string
  description = "Cloud Director vDCs Provider"
}

# CUSTOMER VARIABLES

variable "customer_organization_name" {
  type = string
}

variable "customer_organization_fullname" {
  type = string
}

variable "customer_organization_user" {
  type = string
}

variable "customer_organization_techsupportemail" {
  type = string
}

variable "customer_datacenter_name" {
  type = string
}

variable "customer_datacenter_cpu_quota" {
  type = number
  description = "in MHz"
}

variable "customer_datacenter_memory_quota" {
  type = number
  description = "in MB"
}

variable "customer_datacenter_storage_quota" {
  type = number
  description = "in MB"
}

variable "customer_datacenter_storage_profile" {
  type = string
}

# DEFAULT SETTINGS TO APPLY

