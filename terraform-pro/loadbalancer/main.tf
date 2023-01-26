resource "aws_alb" "alb" {
  name            = "terraform-example-alb"
  security_groups = [var.sec_group]
  subnets         = var.subnet_id
  
}

resource "aws_alb_target_group" "group" {
  name     = "terraform-example-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  stickiness {
    type = "lb_cookie"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/login"
    port = 80
  }
}

resource "aws_alb_target_group_attachment" "tgattachment" {
  count            = length(var.ec2_id)
  target_group_arn = aws_alb_target_group.group.arn
  target_id        = element(var.ec2_id, count.index)
  port             = var.port

  depends_on = [
    aws_alb_target_group.group
  ]

}
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}