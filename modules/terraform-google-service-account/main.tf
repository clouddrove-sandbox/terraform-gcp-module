module "labels" {
  source = "../terraform-google-labels"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_service_account" "service_account" {
  project      = var.project
  account_id   = "clouddrove"
  display_name = var.description
}

locals {
  all_service_account_roles = concat(var.service_account_roles, [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
}

resource "google_project_iam_member" "project" {
  project = var.project
  role    = "roles/editor"
  member  = "user:prashant.yadav@clouddrove.com"
}