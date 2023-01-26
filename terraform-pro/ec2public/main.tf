resource "aws_instance" "ec2-terraform" {
  count = length(var.subnet_id)
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[count.index]
  associate_public_ip_address = "true"
  key_name = var.key_name
  vpc_security_group_ids = [var.sec_group]
  tags = {
    Name = var.name[count.index]
  }


  connection {
    type        = var.connection_type
    user        = var.connection_user
    private_key = file(var.connection_private_key)
    host        = self.public_ip
  }

  provisioner "file" {
    source      = var.file_source
    destination = var.file_destination
  }

  provisioner "remote-exec" {
    inline = var.inline
  }

  provisioner "local-exec" {
    command = "echo Public-ip ${count.index}: ${self.public_ip} >> ./all-ips.txt"
  }

}  
