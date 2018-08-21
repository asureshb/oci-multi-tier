output "ApplicationPassword" {
  value     = "${local.app_password}"
  sensitive = true
}

output "InstanceNames" {
  value = ["${oci_core_instance.instance.*.display_name}"]
}

output "OracleLinuxImage" {
  value = "${lookup(data.oci_core_images.OL75Image.images[0], "display_name")}"
}

output "PrivateIPs" {
  value = ["${oci_core_instance.instance.*.private_ip}"]
}

# Outputs
output "PublicIPs" {
  value = ["${oci_core_instance.instance.*.public_ip}"]
}
