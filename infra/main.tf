terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.47.0"
    }
  }
}


provider "helm" {
  kubernetes {
    config_path = "/home/ancordss/archives/elaniin/kubeconfig-dev" # Asegúrate de apuntar al archivo de configuración correcto
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}



provider "kubernetes" {
  config_path = "/home/ancordss/archives/elaniin/kubeconfig-dev"
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "google_project_service" "monitoring_api" {
  project = var.project_id
  service = "monitoring.googleapis.com"
}

resource "google_project_service" "logging_api" {
  project = var.project_id
  service = "logging.googleapis.com"
  
}


module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  version = "24.1.0"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
  
}

resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}"
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "6.0.0"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"

  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]

  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

data "google_client_config" "default" {}



module "gke" {
  source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version                = "24.1.0"
  project_id             = var.project_id
  name                   = "${var.cluster_name}-${var.env_name}"
  regional               = true
  region                 = var.region
  network                = module.gcp-network.network_name
  subnetwork             = module.gcp-network.subnets_names[0]
  ip_range_pods          = var.ip_range_pods_name
  ip_range_services      = var.ip_range_services_name
  
  node_pools = [
    {
      name                      = "node-pool"
      machine_type              = "e2-medium"
      node_locations            = "europe-west1-b,europe-west1-c,europe-west1-d"
      min_count                 = 1
      max_count                 = 2
      disk_size_gb              = 30
    },
  ]
}


resource "null_resource" "get_kubeconfig" {
  provisioner "local-exec" {
    command = <<EOT
      gcloud container clusters get-credentials ${var.project_id}-dev --region=${var.region}
    EOT
  }
  depends_on = [module.gke]
}

output "kubeconfig_done" {
  value = null_resource.get_kubeconfig.id
}

module "monitoring" {
  source = "./../modules/monitoring"

  depends_on = [null_resource.get_kubeconfig]
}


module "mongo" {
  source   = "./../modules/mongo_deployment"
  name     = "mongo"
  replicas = 1
  image    = "mongo"
  port     = 27017
  depends_on = [module.monitoring]
  
}

module "backend" {
  source               = "./../modules/flask_backend_deployment"
  name                 = "backend"
  replicas             = 1
  image                = "us-east1-docker.pkg.dev/entrevista123/flask-demo-app1/flask-demo-app1:latest"
  port                 = 9091
  flask_server_port    = "9091"
  # cpu_requests         = "100m"
  # cpu_limits           = "500m"
  min_replicas         = 1
  max_replicas         = 5
  cpu_target_utilization = 70

   backend_container_resources = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  depends_on = [module.mongo]
}


module "web" {
  source               = "./../modules/nginx_front_deployment"
  replicas             = 1
  # cpu_requests         = "100m"
  # cpu_limits           = "500m"
  min_replicas         = 1
  max_replicas         = 5
  cpu_target_utilization = 70

  container_resources = {
    requests = {
      cpu    = "100m"
      memory = "128Mi"
    }
    limits = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  depends_on = [module.backend]
}