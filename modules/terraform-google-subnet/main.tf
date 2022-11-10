module "labels" {
  source = "../terraform-google-labels"

  name        = var.name
  environment = var.environment
  label_order = var.label_order
}

resource "google_compute_subnetwork" "subnetwork" {
  count = var.module_enabled ? 1 : 0

  project     = var.project
  network     = var.network
  region      = var.region
  name        = module.labels.name
  description = var.description

  private_ip_google_access = var.private_ip_google_access
  ip_cidr_range            = cidrsubnet(var.ip_cidr_range, 0, 0)

  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_ranges

    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = var.log_config
    content {
      aggregation_interval = try(log_config.value, "aggregation_interval", null)
      flow_sampling        = try(log_config.value, "flow_sampling", null)
      metadata             = try(log_config.value, "metadata", null)
      metadata_fields      = try(log_config.value, "metadata_fields", null)
      filter_expr          = try(log_config.value, "filter_expr", null)
    }
  }

  dynamic "timeouts" {
    for_each = try([var.module_timeouts.google_compute_subnetwork], [])

    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  depends_on = [var.module_depends_on]
}

resource "google_compute_global_address" "default" {
  count         = var.module_enabled ? 1 : 0
  project       = var.project
  name          = format("%s-global-address", module.labels.name)
  address_type  = var.address_type
  purpose       = var.purpose
  network       = var.network
  prefix_length = var.prefix_length
  address       = var.private_service_connect_ip
}

resource "google_service_networking_connection" "default" {
  count                   = var.module_enabled ? 1 : 0
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [join("", google_compute_global_address.default.*.name)]
}

resource "google_compute_firewall" "default" {
  count   = var.module_enabled ? 1 : 0
  name    = format("%s-firewall", module.labels.name)
  network = var.network

  dynamic "allow" {
    for_each = var.allow

    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  source_ranges = var.source_ranges
}

resource "google_compute_router" "default" {
  count   = var.module_enabled ? 1 : 0
  name    = format("%s-router", module.labels.name)
  network = var.network
  bgp {
    asn = var.asn
  }
}

resource "google_compute_address" "default" {
  count  = var.module_enabled ? 1 : 0
  name   = format("%s-address", module.labels.name)
  region = var.region
}

resource "google_compute_router_nat" "nat" {
  count                              = var.module_enabled ? 1 : 0
  name                               = format("%s-router-nat", module.labels.name)
  router                             = join("", google_compute_router.default.*.name)
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  nat_ips                            = google_compute_address.default.*.self_link
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat

  log_config {
    enable = true
    filter = var.filter
  }
}

resource "google_compute_route" "default" {
  count            = var.module_enabled ? 1 : 0
  name             = format("%s-route", module.labels.name)
  dest_range       = var.dest_range
  network          = var.network
  next_hop_gateway = var.next_hop_gateway
  priority         = var.priority
}