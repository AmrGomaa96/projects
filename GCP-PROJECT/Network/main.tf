resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "management" {
  name          = var.management-subnet_name
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-east1"
}
 
resource "google_compute_subnetwork" "restricted" {
  name          = var.restricted-subnet_name
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.0.2.0/24"
  region        = "asia-east1"
  private_ip_google_access = true
}

resource "google_compute_firewall" "management-subnet_firewall" {
  name    = "management-subnet-firewall"
  network = google_compute_network.vpc.id
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]
  target_tags = ["management-vm"]
  priority = 100
  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }
}

# resource "google_compute_router" "router" {
#   name    = "managment-router"
#   region  = "asia-east1"
#   network = google_compute_network.vpc.id
# }

# resource "google_compute_address" "nat_ip" {
#   name = "nat-ip"
#   region = "asia-east1"
# }


# resource "google_compute_router_nat" "nat" {
#   name                               = "managment-nat"
#   router                             = google_compute_router.router.name
#   region                             = google_compute_router.router.region
#   nat_ip_allocate_option             = "MANUAL_ONLY"
#   nat_ips                            = google_compute_address.nat_ip.*.self_link
#   source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   subnetwork {
#     name                    = google_compute_subnetwork.management.id
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }
# }

resource "google_compute_router" "router" {
  name    = "router"
  network = google_compute_network.vpc.id
  region  = "asia-east1"
}
 resource "google_compute_router_nat" "nat" {
  name                               = "my-nat"
  router                             = google_compute_router.router.name
  region                             = "asia-east1"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.management.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}


