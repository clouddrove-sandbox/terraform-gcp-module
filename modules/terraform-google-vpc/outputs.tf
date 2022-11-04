output "vpc" {
  description = "The outputs of the created VPC."
  value       = try(google_compute_network.vpc[0], null)
}
