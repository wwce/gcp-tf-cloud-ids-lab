# -----------------------------------------------------------------------------------
# Outputs
output "A-SSH_attacker" {
  value = "ssh kali@${module.vmseries.nic0_ips["vmseries01"]}"
}

output "B-URL_vmseries" {
  value = "https://${module.vmseries.nic1_ips["vmseries01"]}"
}

output "C-URL_juiceshop" {
  value = "http://${module.vmseries.nic0_ips["vmseries01"]}:3000"
}

output "D-URL_jenkins18" {
  value = "http://${module.vmseries.nic0_ips["vmseries01"]}:8080"
}



