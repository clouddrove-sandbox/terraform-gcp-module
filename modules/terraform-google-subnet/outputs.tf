output "subnetwork" {
  value       = try(google_compute_subnetwork.subnetwork, null)
  description = "The created subnet resource"
}

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}

output "public_subnetwork_name" {
  description = "A reference (self_link) to the VPC network"
  value       = join("", google_compute_subnetwork.subnetwork.*.self_link)
}
