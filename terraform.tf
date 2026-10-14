terraform {
  required_providers {
    # Cloud Director provider
    vcd = {
      source = "vmware/vcd"
    }
    # random generator provider
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}