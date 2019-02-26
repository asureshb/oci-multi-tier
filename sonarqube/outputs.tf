output "ApplicationUser" {
  value = "admin"
}

output "ApplicationPassword" {
  value     = "${ var.app_password == "" ? local.app_password : "Password provided as input" }"
  sensitive = true
}

output "DatabaseUser" {
  value = "postgres"
}

output "DatabasePassword" {
  value     = "${ var.database_password == "" ? local.peer_password : "Password provided as input" }"
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
