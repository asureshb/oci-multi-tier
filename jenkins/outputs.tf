output "ApplicationUser" {
  value = "user"
}

output "ApplicationPassword" {
  value     = "${local.app_password}"
  sensitive = true
}

output "InstanceNames" {
  value = ["${oci_core_instance.instance.*.display_name}"]
}

output "PublicIPs" {
  value = ["${oci_core_instance.instance.*.public_ip}"]
}

output "ApplicationStatus" {
  value = "${ var.ssh_private_key_path == "" ? "Your application is being deployed. Wait a few minutes until it finishes." : "Your application is already deployed. You can already access!" }"
}
