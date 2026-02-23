terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
    }

    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}