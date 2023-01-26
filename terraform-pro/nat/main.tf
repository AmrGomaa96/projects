#Elastic IP for NAT 
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [ var.nat_depends_on ]
}


#nat
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = var.nat_subnet_id
  depends_on    = [ var.nat_depends_on ]
  tags = {
    Name        = var.nat_name
  }
}
