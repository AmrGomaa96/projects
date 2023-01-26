output "Load_Balancer_dns" {

  value = aws_lb.network_lb.dns_name

}