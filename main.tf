terraform {}

provider "google" {
  #project     = var.project_id
  region      = var.region
  #credentials = "account_host.json"
}

resource "random_pet" "main" {
  length = 1
}

data "google_compute_zones" "main" {
  region = var.region
}

locals {
  prefix = random_pet.main.id
}

resource "google_project_service" "service_networking" {
  #project = var.project_id
  service = "servicenetworking.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "ids" {
  #project = var.project_id
  service = "ids.googleapis.com"
  disable_dependent_services = true
  depends_on = [
    google_project_service.service_networking
  ]
}


# -----------------------------------------------------------------------------------
# Networking
module "vpc_trust" {
  source               = "./modules/vpc/"
  vpc                  = "${local.prefix}-trust-vpc"
  delete_default_route = false
  allowed_sources      = ["0.0.0.0/0"]

  subnets = {
    "${var.region}-trust-subnet" = {
      region                = var.region,
      cidr                  = var.cidrs_trust[0]
      private_google_access = true
    }
  }
  depends_on = [
    google_project_service.service_networking,
    google_project_service.ids
  ]
}

resource "google_compute_global_address" "private_ip_alloc" {
  name          = "private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc_trust.vpc_self_link
}

resource "google_service_networking_connection" "foobar" {
  network                 = module.vpc_trust.vpc_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}


# -----------------------------------------------------------------------------------
# Kali Linux VM
resource "google_compute_instance" "default" {
  name         = "${local.prefix}-kali"
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.main.names[0]
  tags         = ["kali"]

  boot_disk {
    initialize_params {
      image = var.image_kali
    }
  }

  network_interface {
    subnetwork = module.vpc_trust.subnet_self_link["${var.region}-trust-subnet"]
    network_ip = var.ip_kali
    access_config {}
  }

  service_account {
    scopes = var.service_scopes
  }
}


# -----------------------------------------------------------------------------------
# Jenkins VM
resource "google_compute_instance" "jenkins" {
  name         = "${local.prefix}-jenkins"
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.main.names[0]
  tags         = ["jenkins"]

  boot_disk {
    initialize_params {
      image = var.image_jenkins
    }
  }

  network_interface {
    subnetwork = module.vpc_trust.subnet_self_link["${var.region}-trust-subnet"]
    network_ip = var.ip_jenkins
    access_config {}
  }


  service_account {
    scopes = var.service_scopes
  }
}

# -----------------------------------------------------------------------------------
# Juice Shop VM
variable "public_key_path" {
  default = "~/.ssh/gcp-demo.pub"
}

resource "google_compute_instance" "juice_shop" {
  name         = "${local.prefix}-juice-shop"
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.main.names[0]
  tags         = ["juice-shop"]


  boot_disk {
    initialize_params {
      image = var.image_juice
    }
  }

  network_interface {
    subnetwork = module.vpc_trust.subnet_self_link["${var.region}-trust-subnet"]
    network_ip = var.ip_juice
    access_config {}
  }

  service_account {
    scopes = var.service_scopes
  }

}