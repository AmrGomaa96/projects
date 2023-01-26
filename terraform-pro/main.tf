module "main" {
    source = "./vpc"
    vpc_cidr="10.0.0.0/16"
    vpc_name="my_vpc"
}
#internet_gateway
module "gateway"{
    source = "./internet_gateway"
    vpc_id = module.main.vpc-id
    internet_gateway_name = "my_gateway"
}

#subnets
module "subnet"{
    source = "./subnets"
    vpc_id     = module.main.vpc-id
    cidr_subnet = {
    "public1" = "10.0.0.0/24"
    "private1" = "10.0.1.0/24"
    "public2" = "10.0.2.0/24"
    "private2" = "10.0.3.0/24"
}
    aZ = {
    "public1"="us-east-1a"
    "private1"="us-east-1a"
    "public2"="us-east-1b"
    "private2"="us-east-1b"
    }
    egress_cidr = "0.0.0.0/0"
    ingress_cider = "0.0.0.0/0"
    int_gateway = module.gateway.internet_gw_id
    nat_gateway = module.nat.nat_gw_id
    public_keys=["public1","public2"]
    private_keys=["private1","private2"]
}



#nat
module "nat" {
    source = "./nat"
    nat_subnet_id= module.subnet.subnet_id[2]
    nat_name = "nat"
    nat_depends_on = module.gateway
}

module "securityGroup" {
  source               = "./securitygroup"
  vpcid                = module.main.vpc-id
  pup-cidr             = "0.0.0.0/0"
  sg_name              = "security_group"
  sg_description       = "security_group"
  sg_from_port_ingress = 80
  sg_to_port_ingress   = 80
  sg_protocol_ingress  = "tcp"
  sg_from_port_egress  = 0
  sg_to_port_egress    = 0
  sg_protocol_egress   = "-1"
}

module "pub_instance"{
    source = "./ec2public"
    ami = "ami-00874d747dde814fa"
    instance_type = "t2.micro"
    key_name = "iti"
    subnet_id = [module.subnet.subnet_id[2],module.subnet.subnet_id[3]]
    sec_group = module.securityGroup.sg_id
    name = ["public1","public2"]
    connection_type        = "ssh"
    connection_user        = "ubuntu"
    connection_private_key = "./iti.pem"
    file_source            = "./nginx.sh"
    file_destination       = "/tmp/nginx.sh"
    inline                 = ["chmod 777 /tmp/nginx.sh", "/tmp/nginx.sh ${module.nlb.Load_Balancer_dns}"]

}
module "priv_instance"{
    source = "./ec2private"
    ami = "ami-00874d747dde814fa"
    instance_type = "t2.micro"
    key_name = "iti"
    subnet_id = [module.subnet.subnet_id[0],module.subnet.subnet_id[1]]
    sec_group = module.securityGroup.sg_id
    name = ["private1","private2"]

}
module "alb" {
    source = "./loadbalancer"
    vpc_id    = module.main.vpc-id
    sec_group = module.securityGroup.sg_id
    subnet_id = [module.subnet.subnet_id[2],module.subnet.subnet_id[3]]
    ec2_id = module.pub_instance.instance_id
    port = "80"
    
}
module "nlb"{
    source = "./networklb"
    name = "networklb"
    subnets = [module.subnet.subnet_id[0],module.subnet.subnet_id[1]]
    lb_internal = true
    listener_port = 80
    listener_protocol= "TCP"
    target_name = "network"
    target_port = 80
    target_protocol = "TCP"
    vpcid= module.main.vpc-id
    health_protocol = "TCP"
    ec2_ids = module.priv_instance.instance_id
    attach_target_port = 80
    }

module "s3"{
    source = "./s3"
    name = "terraform-statefiles-itilabs2023"
}

module "dynamodb"{
  source = "./dynamodb"
  name           = "terraform_locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute_name = "LockID"
  type = "S"
  }