# output "subnet_id" {
#   value       = aws_subnet.subnet[*].id
#   description = "The ID of the subnet."
# }
output "subnet_id" {
  value = [for subnet in aws_subnet.subnet : subnet.id ]
}