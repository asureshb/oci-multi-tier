output "ApplicationUser" {
  value = "user"
}

output "ApplicationPassword" {
  value     = "${ var.app_password == "" ? local.app_password : "Password provided as input" }"
  sensitive = true
}

output "InstanceNames" {
  value = ["${oci_core_instance.instance.*.display_name}"]
}

output "PublicIPs" {
  value = ["${oci_core_instance.instance.*.public_ip}"]
}
