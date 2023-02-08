
output "vpc_id" {
  value = google_compute_network.vpc.id
}

output "vpc_name" {
  value = google_compute_network.vpc.name
}
output "management_id" {
  value = google_compute_subnetwork.management.id
}
output "restricted_id" {
  value = google_compute_subnetwork.restricted.id
}

output "restricted_name" {
  value = google_compute_subnetwork.restricted.name
}

# output "nat_address" {
#     value = google_compute_address.nat_ip.address
  
# }
