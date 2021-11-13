# -----------------------------------------------------------------------------------
# Outputs
output "kali_login" {
  value = "ssh kali@${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

output "URL_jenkins" {
  value = "http://${google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip}:8080"
}

output "URL_juice_shop" {
  value = "http://${google_compute_instance.juice_shop.network_interface.0.access_config.0.nat_ip}"
}