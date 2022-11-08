provider "google" {
  project     = var.gcp_project_id
  credentials = var.gcp_credentials
  region      = var.gcp_region
  zone        = var.gcp_zone
}

//provider "kubernetes" {
//  host                   = data.template_file.gke_host_endpoint.rendered
//  token                  = data.template_file.access_token.rendered
//  cluster_ca_certificate = data.template_file.cluster_ca_certificate.rendered
//}


module "vpc" {
  source = "../modules/terraform-google-vpc"

  name        = "vpc"
  environment = "network"
  label_order = ["name", "environment"]

  project                         = "clouddrove"
  auto_create_subnetworks         = false
  routing_mode                    = "GLOBAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
}


module "subnet" {
  source = "../modules/terraform-google-subnet"

  name        = "subnet"
  environment = "Dev"
  label_order = ["name", "environment"]

  private_ip_google_access = true
  network                  = module.vpc.vpc.id
}
//
//module "kms" {
//  source          = "../modules/terraform-google-kms"
//  project_id      = "clouddrove"
//  keyring         = "Dev-key"
//  location        = var.location
//  keys            = []
//  prevent_destroy = false
//}
//
//
//module "firewall-ssh" {
//  source = "../modules/terraform-google-firewall"
//
//  name        = "firewall-ssh"
//  environment = "Dev"
//  label_order = ["name", "environment"]
//
//  network       = module.vpc.vpc.id
//  protocol      = "tcp"
//  ports         = ["22"]
//  source_ranges = ["0.0.0.0/0"]
//}
//
//data "google_client_config" "client" {}
//data "google_client_openid_userinfo" "terraform_user" {}
//
//module "gke_cluster" {
//  source = "../modules/terraform-google-gke"
//
//  name        = "gke"
//  environment = "Dev"
//  label_order = ["name", "environment"]
//
//  project  = var.gcp_project_id
//  location = var.location
//
//
//  network    = module.vpc.vpc.id
//  subnetwork = module.subnet.public_subnetwork_name
//  //  cluster_secondary_range_name = ""
//  //  services_secondary_range_name = ""
//
//  disable_public_endpoint = "false"
//  resource_labels = {
//    environment = "testing"
//  }
//  cluster            = module.gke_cluster.name
//  initial_node_count = "1"
//  min_node_count     = "2"
//  max_node_count     = "7"
//  location_policy    = "BALANCED"
//  auto_repair        = "true"
//  auto_upgrade       = "false"
//
//  image_type              = "cos_containerd"
//  machine_type            = "e2-medium"
//  disk_size_gb            = "50"
//  disk_type               = "pd-standard"
//  preemptible             = false
//  cluster_create_timeouts = "30m"
//  cluster_update_timeouts = "30m"
//  cluster_delete_timeouts = "30m"
//}
//
//# ---------------------------------------------------------------------------------------------------------------------
//# WORKAROUNDS
//# ---------------------------------------------------------------------------------------------------------------------
//
//
//data "template_file" "gke_host_endpoint" {
//  template = module.gke_cluster.endpoint
//}
//
//data "template_file" "access_token" {
//  template = data.google_client_config.client.access_token
//}
//
//data "template_file" "cluster_ca_certificate" {
//  template = module.gke_cluster.cluster_ca_certificate
//}
//
//
//module "gke_service_account" {
//  source = "../modules/terraform-google-service-account"
//
//  name        = "gke_service_account"
//  environment = "Dev"
//  label_order = ["name", "environment"]
//
//  project = var.gcp_project_id
//  length  = 16
//  special = false
//  upper   = false
//}
