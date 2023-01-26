resource "aws_instance" "ec2-private" {
  count = length(var.subnet_id)
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[count.index]
  key_name = var.key_name
  vpc_security_group_ids = [var.sec_group]
  tags = {
    Name = var.name[count.index]
  }
 
      user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo chmod 777 /var/www/html
    sudo chmod 777 /var/www/html/index.nginx-debian.html
    sudo echo '<h1>This is private-ec2 ${count.index +1} </h1>' > /var/www/html/index.nginx-debian.html
    sudo systemctl restart nginx
  EOF



provisioner "local-exec" {
    command = "echo Private-ip ${count.index}: ${self.private_ip} >> ./all-ips.txt"
  }
  
}
