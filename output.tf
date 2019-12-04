output "gateway_ip4" {
  value = google_compute_network.vpc_network.gateway_ipv4
}

output "self_link" {
  value = google_compute_network.vpc_network.self_link
}

output "ipv4_range" {
  value = google_compute_network.vpc_network.ipv4_range
}

output "gateway_ipv4" {
  value = google_compute_network.vpc_network.gateway_ipv4
}
