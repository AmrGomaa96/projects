#subnet
resource "aws_subnet" "subnet" {
  #count = length(var.cidr_subnet)
  for_each = var.cidr_subnet
  cidr_block = each.value
  availability_zone = var.aZ[each.key]
  vpc_id     = var.vpc_id
  

  tags = {
    Name = each.key
  }
} 

#Routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "private-route-table"
  }
}
#Routing table for public subnet
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "public-route-table"
  }
}

#aws_route
resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block =  var.egress_cidr
  gateway_id             = var.int_gateway
}
resource "aws_route" "private" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = var.ingress_cider
  nat_gateway_id         = var.nat_gateway
}
  
#Route table associations
resource "aws_route_table_association" "public" {
    count = length(var.public_keys)
    subnet_id      = aws_subnet.subnet[var.public_keys[count.index]].id
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
    count = length(var.private_keys)
    subnet_id      = aws_subnet.subnet[var.private_keys[count.index]].id
    route_table_id = "${aws_route_table.private.id}"
}
