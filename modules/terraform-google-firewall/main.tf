module "labels" {
  source = "../terraform-google-labels"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_compute_firewall" "new-firewall" {
  name    = var.name
  network = var.network

  allow {
    protocol = var.protocol
    ports    = var.ports
  }

  source_ranges = var.source_ranges
}