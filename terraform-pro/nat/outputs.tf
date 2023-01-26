output "nat_gw_id" {
  value = aws_nat_gateway.nat.id
}

output "elistic_ip" {
  value = aws_eip.nat_eip.id
}