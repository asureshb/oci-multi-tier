# Get a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}

locals {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.availability_domain - 1],"name")}"
}

resource "oci_core_virtual_network" "VCN" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_VCN"
  dns_label      = "vcn"
  cidr_block     = "10.0.0.0/16"
}

resource "oci_core_subnet" "Subnet" {
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.deployment_short_name}_Subnet"
  dns_label           = "subnet"
  availability_domain = "${local.availability_domain}"
  vcn_id              = "${oci_core_virtual_network.VCN.id}"
  cidr_block          = "10.0.1.0/24"
  route_table_id      = "${oci_core_route_table.RT.id}"
  security_list_ids   = ["${oci_core_security_list.SL.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.VCN.default_dhcp_options_id}"
}

resource "oci_core_internet_gateway" "IG" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_IG"
  vcn_id         = "${oci_core_virtual_network.VCN.id}"
}

resource "oci_core_route_table" "RT" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_RT"
  vcn_id         = "${oci_core_virtual_network.VCN.id}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.IG.id}"
  }
}

# Firewall rules
resource "oci_core_security_list" "SL" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_SL"
  vcn_id         = "${oci_core_virtual_network.VCN.id}"

  # Allow outbound tcp traffic on all ports
  egress_security_rules = [
    {
      destination = "0.0.0.0/0"
      protocol    = "6"
    },
  ]

  ingress_security_rules = [
    {
      # Allow 22 from everywhere
      source   = "0.0.0.0/0"
      protocol = "6"

      tcp_options {
        min = 22
        max = 22
      }
    },
    {
      # Allow 27017 from the VCN only
      source   = "${oci_core_virtual_network.VCN.cidr_block}"
      protocol = "6"

      tcp_options = {
        min = 27017
        max = 27017
      }
    },
  ]
}
