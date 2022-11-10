########################## provider #########################################
provider "google" {
  project     = var.gcp_project_id
  credentials = var.gcp_credentials
  region      = var.gcp_region
  zone        = var.gcp_zone
}

########################## provider-kubernetes ###############################

provider "kubernetes" {
  host                   = data.template_file.gke_host_endpoint.rendered
  token                  = data.template_file.access_token.rendered
  cluster_ca_certificate = data.template_file.cluster_ca_certificate.rendered
}

########################## vpc ##############################################

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

########################## subnet ##############################################

module "subnet" {
  source = "../modules/terraform-google-subnet"

  name        = "subnet"
  environment = "network"
  label_order = ["name", "environment"]

  private_ip_google_access           = true
  network                            = module.vpc.vpc.id
  address_type                       = "INTERNAL"
  prefix_length                      = 16
  purpose                            = "VPC_PEERING"
  allow                              = [{ "protocol" : "tcp", "ports" : ["1-65535"] }]
  source_ranges                      = [var.ip_cidr_range]
  asn                                = 64514
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  filter                             = "ERRORS_ONLY"
  dest_range                         = "0.0.0.0/0"
  next_hop_gateway                   = "default-internet-gateway"
  priority                           = 1000
}

########################## kms ##############################################

module "kms" {
  source          = "../modules/terraform-google-kms"
  project_id      = "clouddrove"
  keyring         = "deop-key"
  location        = var.location
  keys            = ["test"]
  prevent_destroy = true
  service_accounts = ["serviceAccount:service-943862527560@container-engine-robot.iam.gserviceaccount.com"]
  role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
}

########################## firewall-ssh ##############################################

module "firewall-ssh" {
  source = "../modules/terraform-google-firewall"

  name        = "firewall-ssh"
  environment = "Dev"
  label_order = ["environment", "name"]

  network       = module.vpc.vpc.id
  protocol      = "tcp"
  ports         = ["22"]
  source_ranges = ["0.0.0.0/0"]
}

data "google_client_config" "client" {}
data "google_client_openid_userinfo" "terraform_user" {}

########################## gke_cluster ##############################################

module "gke_cluster" {
  source = "../modules/terraform-google-gke"

  name        = "gke"
  environment = "Dev"
  label_order = ["environment", "name"]

  project  = var.gcp_project_id
  location = var.location


  network    = module.vpc.vpc.id
  subnetwork = module.subnet.public_subnetwork_name
  //  cluster_secondary_range_name = ""
  //  services_secondary_range_name = ""

  disable_public_endpoint = "false"
  resource_labels = {
    environment = "testing"
  }
  cluster            = module.gke_cluster.name
  initial_node_count = "1"
  secrets_encryption_kms_key = module.kms.key
  ###############################  autoscaling  #########################

  min_node_count  = "2"
  max_node_count  = "7"
  location_policy = "BALANCED"

  ##################################### management #####################

  auto_repair  = "true"
  auto_upgrade = "false"

  ##################################  node_config ##########################

  image_type      = "cos_containerd"
  machine_type    = "e2-medium"
  disk_size_gb    = "50"
  disk_type       = "pd-standard"
  preemptible     = false
//  max_surge       = 0
//  max_unavailable = 0
  ###############################  timeouts ###################################

  cluster_create_timeouts = "30m"
  cluster_update_timeouts = "30m"
  cluster_delete_timeouts = "30m"
}

# ---------------------------------------------------------------------------------------------------------------------
# WORKAROUNDS
# ---------------------------------------------------------------------------------------------------------------------


data "template_file" "gke_host_endpoint" {
  template = module.gke_cluster.endpoint
}

data "template_file" "access_token" {
  template = data.google_client_config.client.access_token
}

data "template_file" "cluster_ca_certificate" {
  template = module.gke_cluster.cluster_ca_certificate
}

########################## gke_service_account ##############################################

module "gke_service_account" {
  source = "../modules/terraform-google-service-account"

  name        = "service_account"
  environment = "Dev"
  label_order = ["environment", "name"]

  project = var.gcp_project_id
  length  = 16
  special = false
  upper   = false
}
