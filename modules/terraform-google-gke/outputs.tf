output "name" {
  description = "The name of the cluster master. This output is used for interpolation with node pools, other modules."
  value       = join("",google_container_cluster.cluster.*.name)
}

output "master_version" {
  description = "The Kubernetes master version."
  value       = join("",google_container_cluster.cluster.*.master_version)
}

output "endpoint" {
  description = "The IP address of the cluster master."
  sensitive   = true
  value       = join("",google_container_cluster.cluster.*.endpoint)
}

output "client_certificate" {
  description = "Public certificate used by clients to authenticate to the cluster endpoint."
  value       = base64decode(google_container_cluster.cluster[0].master_auth[0].client_certificate)
}

output "client_key" {
  description = "Private key used by clients to authenticate to the cluster endpoint."
  value       = base64decode(google_container_cluster.cluster[0].master_auth[0].client_key)
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster."
  value       = base64decode(google_container_cluster.cluster[0].master_auth[0].cluster_ca_certificate)
}