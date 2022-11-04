provider "google" {
  project     = var.gcp_project_id
  credentials = var.gcp_credentials
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "kubernetes" {

  host                   = data.template_file.gke_host_endpoint.rendered
  token                  = data.template_file.access_token.rendered
  cluster_ca_certificate = data.template_file.cluster_ca_certificate.rendered
}


module "vpc" {
  source = "../modules/terraform-google-vpc"

  name        = "vpc"
  environment = "network"
  label_order = ["name", "environment"]

  project                         = "clouddrove"
  auto_create_subnetworks         = false
  routing_mode                    = "REGIONAL"
  mtu                             = 1460
  delete_default_routes_on_create = false
}

module "subnet" {
  source = "../modules/terraform-google-subnet"

  name        = "subnet"
  environment = "network"
  label_order = ["name", "environment"]

  private_ip_google_access = true
  network   = module.vpc.vpc.id
}

data "google_client_config" "client" {}
data "google_client_openid_userinfo" "terraform_user" {}

module "gke_cluster" {
  source = "../modules/terraform-google-gke"


  name        = "gke"
  environment = "cluster"
  label_order = ["name", "environment"]

  project  = var.gcp_project_id
  location = var.location

  network                      = module.vpc.vpc.id
  subnetwork                   = module.subnet.public_subnetwork_name
//  cluster_secondary_range_name = ""
//  services_secondary_range_name = ""

  disable_public_endpoint = "false"

  resource_labels = {
    environment = "testing"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A NODE POOL
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_node_pool" "node_pool" {
  provider = google-beta

  name     = "node-pool"
  project  = var.gcp_project_id
  location = var.location
  cluster  = module.gke_cluster.name
  initial_node_count = "1"

  autoscaling {
    min_node_count = "2"
    max_node_count = "7"
    location_policy = "BALANCED"
  }

  management {
    auto_repair  = "true"
    auto_upgrade = "false"
  }

  node_config {
    image_type   = "cos_containerd"
    machine_type = "e2-medium"

    labels = {
      all-pools-example = "true"
    }


    disk_size_gb = "50"
    disk_type    = "pd-standard"
    preemptible  = false

    service_account = module.gke_service_account.email

  }

  lifecycle {
    ignore_changes = [initial_node_count ]
    create_before_destroy = false

  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}

resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "gcloud beta container clusters get-credentials ${module.gke_cluster.name} --region ${var.gcp_region} --project ${var.gcp_project_id}"

    environment = {
      KUBECONFIG = var.kubectl_config_path != "" ? var.kubectl_config_path : ""
    }
  }

  depends_on = [google_container_node_pool.node_pool]
}

resource "kubernetes_cluster_role_binding" "user" {
  metadata {
    name = "admin-user"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = data.google_client_openid_userinfo.terraform_user.email
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "system:masters"
    api_group = "rbac.authorization.k8s.io"
  }
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

module "gke_service_account" {
  source = "../modules/terraform-google-service-account"

  name        = "gke"
  environment = "service_account"
  label_order = ["name", "environment"]

  project     = var.gcp_project_id
}

resource "random_string" "suffix" {
  length  = 16
  special = false
  upper   = false
}
