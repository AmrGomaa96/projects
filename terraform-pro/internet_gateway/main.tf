#internet-gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = var.internet_gateway_name
  }
}

