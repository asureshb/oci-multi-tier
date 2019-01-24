# Instances

locals {
  hostname_prefix = "${var.deployment_short_name}-${local.application}"
}

data "oci_core_images" "OLImage" {
  # Oracle Linux 7.6 images
  compartment_id           = "${var.compartment_ocid}"
  shape                    = "${var.instance_shape}"
  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"
}

resource "oci_core_instance" "instance" {
  count = "${var.nodes_count + var.arbiters_count}"

  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_${local.application}${count.index}_${count.index == 0 ? "master" : count.index >= var.nodes_count ? "arbiter" : "slave"}"

  availability_domain = "${local.availability_domain}"

  shape = "${count.index >= var.nodes_count ? var.arbiters_instance_shape : var.instance_shape}"

  source_details {
    source_type = "image"
    source_id   = "${lookup(data.oci_core_images.OLImage.images[0], "id")}"
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.Subnet.id}"
    display_name     = "${var.deployment_short_name}_VNIC${count.index}"
    assign_public_ip = "true"
    hostname_label   = "${local.hostname_prefix}${count.index}"
  }

  metadata {
    ssh_authorized_keys = "${local.ssh_public_key}"
    user_data           = "${base64encode(data.template_file.userdata.*.rendered[count.index])}"
  }
}

resource "null_resource" "waiter" {
  count = "${var.ssh_private_key_path == "" ? 0 : var.nodes_count + var.arbiters_count}"

  triggers {
    instance_ids = "${oci_core_instance.instance.*.id[count.index]}"
  }

  connection {
    host        = "${oci_core_instance.instance.*.public_ip[count.index]}"
    user        = "bitnami"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "20m"
  }

  # Wait for the instances to be ready
  provisioner "remote-exec" {
    inline = [
      "timeout 20m sh -c 'while [ ! -f /opt/bitnami/.firstboot.status ]; do sleep 10s; echo Still initializing the node...; done'",
      "test x$(cat /opt/bitnami/.firstboot.status) = xfalse && echo 'The node failed to initialize.' && exit 1",
      "test x$(cat /opt/bitnami/.firstboot.status) = xtrue || echo 'Timeout initializing the node, it is still starting up...'",
    ]
  }
}

# User data rendering
data "template_file" "userdata" {
  count = "${var.nodes_count + var.arbiters_count}"

  template = "${file(local.bootstrap_file)}"

  vars {
    bundle_tgz_uri = "${local.bundle_tgz_uri}"

    custom_userdata = "${var.custom_userdata}"

    provisioner_shared_unique_id_input = "${oci_core_subnet.Subnet.id}${var.deployment_short_name}"
    provisioner_peer_nodes_count       = "${var.nodes_count + var.arbiters_count}"
    provisioner_peer_nodes_index       = "${count.index}"
    provisioner_peer_nodes_prefix      = "${local.hostname_prefix}"
    provisioner_tier                   = "${count.index == 0 ? "master" : count.index >= var.nodes_count ? "arbiter" : "slave"}"
    provisioner_app_password           = "${local.app_password}"
    provisioner_app_database           = "${var.app_database}"
    provisioner_peer_password          = "${random_string.peer_password.result}"
    provisioner_peer_address           = "${local.hostname_prefix}0.${oci_core_subnet.Subnet.dns_label}.${oci_core_virtual_network.VCN.dns_label}.oraclevcn.com"
  }
}

# Volumes
resource "oci_core_volume" "volume" {
  count = "${var.nodes_count}"

  compartment_id = "${var.compartment_ocid}"
  display_name   = "${var.deployment_short_name}_volume${count.index}"

  availability_domain = "${local.availability_domain}"

  size_in_gbs = "${var.volume_size}"
}

resource "oci_core_volume_attachment" "VA" {
  count = "${var.nodes_count}"

  instance_id     = "${oci_core_instance.instance.*.id[count.index]}"
  attachment_type = "paravirtualized"
  volume_id       = "${oci_core_volume.volume.*.id[count.index]}"

  display_name = "${var.deployment_short_name}_VA${count.index}"
}

# Password generation
resource "random_string" "peer_password" {
  length  = 16
  special = false
}

resource "random_string" "app_password" {
  length  = 12
  special = false
}

locals {
  app_password = "${ var.app_password == "" ? random_string.app_password.result : var.app_password }"
}
