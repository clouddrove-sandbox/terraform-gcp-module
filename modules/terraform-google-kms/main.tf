module "labels" {
  source = "../terraform-google-labels"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_kms_key_ring" "key_ring" {
  count = var.module_enabled ? 1 : 0
  name     = module.labels.id
  project  = var.project_id
  location = var.location
}

resource "google_kms_crypto_key" "key" {
  count           = var.module_enabled && var.prevent_destroy ? length(var.keys) : 0
  name            = var.keys[count.index]
  key_ring        = join("",google_kms_key_ring.key_ring.*.id)
  rotation_period = var.key_rotation_period
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = true
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key" "key_ephemeral" {
  count           = var.module_enabled && var.prevent_destroy ? 0 : length(var.keys)
  name            = var.keys[count.index]
  key_ring        = join("",google_kms_key_ring.key_ring.*.id)
  rotation_period = var.key_rotation_period
  purpose         = var.purpose

  lifecycle {
    prevent_destroy = false
  }

  version_template {
    algorithm        = var.key_algorithm
    protection_level = var.key_protection_level
  }

  labels = var.labels
}

resource "google_kms_crypto_key_iam_binding" "owners" {
  count         = var.module_enabled ? length(var.service_accounts) : 0
  role          = var.role
  crypto_key_id = join("", google_kms_crypto_key.key.*.id)
  members       = compact(split(",", var.service_accounts[count.index]))
}