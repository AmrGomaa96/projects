resource "aws_lb" "network_lb" {
  name               = var.name
  internal           = var.lb_internal
  load_balancer_type = "network"
  subnets            = var.subnets
}


resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.network_lb.arn

  protocol = var.listener_protocol
  port     = var.listener_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NLB_tg.arn
  }
}
resource "aws_lb_target_group" "NLB_tg" {
  name     = var.target_name
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpcid

  health_check {
    enabled  = true
    protocol = var.health_protocol
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(var.ec2_ids)
  target_group_arn = aws_lb_target_group.NLB_tg.arn
  target_id        = element(var.ec2_ids, count.index)
  port             = var.attach_target_port

  depends_on = [
    aws_lb_target_group.NLB_tg
  ]

}
