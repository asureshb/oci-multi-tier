locals {
  application = "mongodb"
  version     = "4.0.6-3-r10"
}

variable "deployment_short_name" {
  description = "Name of the deployment, short way. (e.g. mydeployment)."
  default     = "mydeployment"
}

# Settings for authentication
variable "tenancy_ocid" {
  description = "OCID of the tenancy to be used."
}

variable "user_ocid" {
  description = "OCID of the user to be used."
}

variable "fingerprint" {
  description = "Fingerprint of the ssh deploy key to be used."
}

variable "private_key_path" {
  description = "Path to the private key which fingerprint is above."
}

variable "private_key_password" {
  description = "Password for the private key"
  default     = ""
}

# Location
variable "compartment_ocid" {
  description = "Ocid of the compartment to be used."
}

variable "region" {
  description = "Region to use."
  default     = "us-ashburn-1"
}

variable "availability_domain" {
  description = "Availability domain to be used."
  default     = "1"
}

# Compute
variable "nodes_count" {
  description = "Number of instances to deploy. (Minimum recommended: 3)."
  default     = "3"
}

variable "instance_shape" {
  description = "Size of each instance. (Minimum recommended: VM.Standard2.1)."
  default     = "VM.Standard2.1"
}

variable "volume_size" {
  description = "Size of the data volume in GBs. (Minimum recommended: 50)."
  default     = "50"
}

variable "arbiters_count" {
  description = "Number of arbiters to deploy. Add an arbiter to create an odd number of total nodes. (Choose 0 or 1)."
  default     = "0"
}

variable "arbiters_instance_shape" {
  description = "Size of each arbiter instance. (Minimum recommended: VM.Standard2.1)."
  default     = "VM.Standard2.1"
}

variable "app_password" {
  description = "Application password for MongoDB, username is 'root'. (Auto-generated if not provided)"
  default     = ""
}

variable "app_database" {
  description = "Name of the application database. (e.g. replicaset)."
  default     = "replicaset"
}

variable "bundle_tgz_uri" {
  description = "Link to the provisioner bundle."
  default     = ""
}

locals {
  # Bootstrap script to be executed at init time
  bootstrap_file = "./userdata/bootstrap.sh"

  # Link to the provisioner bundle
  bundle_tgz_uri = "${ var.bundle_tgz_uri == "" ? "https://downloads.bitnami.com/files/nami/provisioner-bundles/provisioner-${local.application}-${local.version}-bundle-oci.tar.gz" : var.bundle_tgz_uri }"
}

variable "custom_userdata" {
  description = "Custom user-data to pass to the bootstrap script."
  default     = ""
}

variable "ssh_public_key_path" {
  description = "Path to the public key used on the instances."
  default     = ""
}

variable "ssh_public_key" {
  description = "Contents of the public key used on the instances. If this variable is set, ssh_public_key_path is ignored."
  default     = ""
}

locals {
  ssh_public_key = "${ var.ssh_public_key == "" ? file(var.ssh_public_key == "" ? var.ssh_public_key_path : "/dev/null") : var.ssh_public_key }"
}
