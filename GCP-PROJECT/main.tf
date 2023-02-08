provider "google" {
  project     = "my-project-377103"
  region      = "asia-east1"
  credentials = file("/home/amr/GCP-PROJECT/service.json")
}

module "network_module" {
  source = "./Network"
  vpc_name = "my-vpc"
  management-subnet_name = "management-subnet"
  restricted-subnet_name = "restricted-subnet"
}

module "VM"{
    source = "./VM"
    vm_name = "private-management-vm"
    machine_type = "f1-micro"
    zone = "asia-east1-a"
    image = "ubuntu-os-cloud/ubuntu-2204-lts"
    subnet_id = module.network_module.management_id
   
    #nat_ip = module.network_module.nat_address
}


module "gke_cluster" {
  source = "./Cluster"
  network_vpc_name= module.network_module.vpc_name
  sub_network_name= module.network_module.restricted_name
}