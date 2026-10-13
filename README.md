# terraform-clouddirector
A hands-on lab on integrating Terraform to a VMware Cloud Director environment.

The goal was to provision a Virtual Data Center (VDC) on Cloud Director based on the needed parameters given as inputs or from a file.
## terraform.tf
The simple definition of the Cloud Director provider for Terraform.

## variables.tf
All the variables definitions and their units.

## main.tf
The real Terraform IaC file.

Here are the elements to be provisioned:

* the connection to Cloud Director endpoint
* a Cloud Director organization, representing a tenant of the final customer
* a Virtual Data Center
* an administrative user that manages the Virtual Data Center itself

If one of those elements is already present, Terraform will try to make it consistent as written in this file (imperative), otherwise it will create them as brand new.

All the elements are built based on a .tfvars file (here omitted, obviously :D ) that injects the names, the values and the quotas desired.

For instance, a new VDC should have:

* 8GHz vCPU
* 16GB vRAM
* 256GB storage



then the variables' values below are read from the .tfvars file:

* *var.customer_datacenter_cpu_quota*
* *var.customer_datacenter_memory_quota*
* *var.customer_datacenter_storage_quota*

## Apply

As soon as .tfvars file is filled (take a look on the *.tfvars.example* file), it is just a matter of *plan* & *apply* and let the magic happen.