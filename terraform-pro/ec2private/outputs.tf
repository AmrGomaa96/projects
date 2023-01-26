output "instance_id" {
  value = tolist(aws_instance.ec2-private.*.id)
  
}