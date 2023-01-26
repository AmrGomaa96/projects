
resource "aws_security_group" "sec-group" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = var.vpcid

   ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.pup-cidr]

  }
  
  ingress {
    from_port   = var.sg_from_port_ingress
    to_port     = var.sg_to_port_ingress
    protocol    = var.sg_protocol_ingress
    cidr_blocks = [var.pup-cidr]

  }
  egress {
    from_port   = var.sg_from_port_egress
    to_port     = var.sg_to_port_egress
    protocol    = var.sg_protocol_egress
    cidr_blocks = [var.pup-cidr]
  }
}