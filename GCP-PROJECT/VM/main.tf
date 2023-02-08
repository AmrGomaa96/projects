
resource "google_service_account" "myservice-account" {
  project = "my-project-377103"
  account_id = "myservice-account"
  display_name = "myservice-account"
}

resource "google_project_iam_member" "binding" {
  project = "my-project-377103"
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.myservice-account.email}"
}


resource "google_compute_instance" "private-management-vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
 
  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  metadata = {
  enable-oslogin = "TRUE"
  }
  tags = ["management-vm"]
  network_interface {
    subnetwork = var.subnet_id
    # access_config {
    #   nat_ip = var.nat_ip
    # }
  }
  service_account {
    email = google_service_account.myservice-account.email
    scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
  metadata_startup_script = <<-EOF
    sudo apt-get install  -y apt-transport-https ca-certificates gnupg
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
    sudo apt-get update && sudo apt-get install google-cloud -y
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    chmod +x kubectl
    mkdir -p ~/.local/bin
    mv ./kubectl ~/.local/bin/kubectl
    kubectl version --client
    sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
    # sudo USE_GKE_GCLOUD_AUTH_PLUGIN: True
    # gcloud container clusters get-credentials private-cluster --zone asia-east1-a --project my-project-377103
  EOF
}
