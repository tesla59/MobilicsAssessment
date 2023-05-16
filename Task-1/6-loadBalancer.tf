locals {
  applications = {
    my-app-00 = {
      machine_type = "t3.micro"
      subnet_id    = aws_subnet.test-private-sg-1.id
    }
    my-app-01 = {
      machine_type = "t3.micro"
      subnet_id    = aws_subnet.test-private-sg-2.id
    }
  }
}

resource "aws_security_group" "ec2_eg1" {
  name   = "ec2-eg1"
  vpc_id = aws_vpc.test-vpc.id
}

resource "aws_security_group" "alb_eg1" {
  name   = "alb-eg1"
  vpc_id = aws_vpc.test-vpc.id
}

resource "aws_security_group_rule" "ingress_ec2_traffic" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

resource "aws_security_group_rule" "ingress_ec2_health_check" {
  type                     = "ingress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_eg1.id
  source_security_group_id = aws_security_group.alb_eg1.id
}

resource "aws_security_group_rule" "ingress_alb_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb_eg1.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_traffic" {
  type                     = "egress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_eg1.id
  source_security_group_id = aws_security_group.ec2_eg1.id
}

resource "aws_security_group_rule" "egress_alb_health_check" {
  type                     = "egress"
  from_port                = 8081
  to_port                  = 8081
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_eg1.id
  source_security_group_id = aws_security_group.ec2_eg1.id
}

resource "aws_instance" "my_app_eg1" {
  for_each = local.applications

  ami           = "ami-test"
  instance_type = each.value.machine_type
  key_name      = "assessment"
  subnet_id     = each.value.subnet_id

  vpc_security_group_ids = [aws_security_group.ec2_eg1.id]

  tags = {
    Name = each.key
  }
}

resource "aws_lb_target_group" "my_app_eg1" {
  name       = "my-app-eg1"
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.test-vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 8081
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "my_app_eg1" {
  for_each = aws_instance.my_app_eg1

  target_group_arn = aws_lb_target_group.my_app_eg1.arn
  target_id        = each.value.id
  port             = 8080
}

resource "aws_lb" "my_app_eg1" {
  name               = "my-app-eg1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_eg1.id]

  subnets = [
    aws_subnet.test-public-sg-1.id,
    aws_subnet.test-public-sg-2.id
  ]
}

resource "aws_lb_listener" "http_eg1" {
  load_balancer_arn = aws_lb.my_app_eg1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_eg1.arn
  }
}
