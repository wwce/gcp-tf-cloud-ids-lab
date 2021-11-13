
project_id     = "$GOOGLE_CLOUD_PROJECT"
region         = "us-east1"
cidrs_trust    = ["192.168.11.0/24"]
image_jenkins  = "https://www.googleapis.com/compute/v1/projects/panw-utd-public-cloud/global/images/utd-gcp-jenkins-server"
image_kali     = "https://www.googleapis.com/compute/v1/projects/savvy-droplet-229621/global/images/kali37516s"
image_juice    = "https://www.googleapis.com/compute/v1/projects/panw-gcp-team-testing/global/images/juice-shop-11-2021"
ip_jenkins     = "192.168.11.4"
ip_kali        = "192.168.11.3"
ip_juice       = "192.168.11.2"
service_scopes = ["cloud-platform"]