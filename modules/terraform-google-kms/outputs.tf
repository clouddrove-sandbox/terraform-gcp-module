output "keyring" {
  value       = google_kms_key_ring.key_ring.id
  description = "Self link of the keyring."

}

output "keyring_resource" {
  value       = google_kms_key_ring.key_ring
  description = "Keyring resource."

}

output "keys" {
  value       = local.keys_by_name
  description = "Map of key name => key self link."

}

output "keyring_name" {
  value       = google_kms_key_ring.key_ring.name
  description = "Name of the keyring."

}