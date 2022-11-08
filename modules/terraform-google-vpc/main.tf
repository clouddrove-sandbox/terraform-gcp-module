module "labels" {
  source = "../terraform-google-labels"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_compute_network" "vpc" {
  count = var.module_enabled ? 1 : 0

  description = var.description
  project     = var.project

  auto_create_subnetworks         = var.auto_create_subnetworks
  routing_mode                    = var.routing_mode
  mtu                             = var.mtu
  delete_default_routes_on_create = var.delete_default_routes_on_create

  depends_on = [var.module_depends_on]
}