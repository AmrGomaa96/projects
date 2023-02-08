resource "google_service_account" "GKE-service" {
  account_id   = "gke-service"
  display_name = "gke-service"
}

resource "google_project_iam_member" "binding" {
  project = "my-project-377103"
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.GKE-service.email}"
}

resource "google_container_cluster" "private-cluster" {
  name     = "private-cluster"
  location = "asia-east1-a"
  network = var.network_vpc_name
  subnetwork = var.sub_network_name
  release_channel {
    channel = "REGULAR"
  }


  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {

  }

  master_authorized_networks_config {
    cidr_blocks {
      display_name = "management-subnet"
      cidr_block = "10.0.1.0/24"
    }
  }
}

 
resource "google_container_node_pool" "private-cluster-node-pool" {
  name       = "private-cluster-node-pool"
  location   = "asia-east1-a"
  cluster    = google_container_cluster.private-cluster.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_type    = "pd-standard"
    disk_size_gb = 10
    image_type   = "ubuntu_containerd"
    service_account = google_service_account.GKE-service.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"

    ]
  }
}