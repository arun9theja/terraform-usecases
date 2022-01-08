resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = var.public_subnet_id
  tags = {
    Environment = "tqa"
  }

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "test-tga" {
  count            = length(var.instance_id)
  target_group_arn = aws_lb_target_group.test-tg.arn
  target_id        = var.instance_id[count.index]
  port             = 80
}

resource "aws_lb_target_group" "test-tg" {
  name     = "tf-test-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_security_group" "alb-sg" {
  name        = "test-alb-sg"
  description = "Allow http inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "alb-to-ec2-egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb-sg.id
  source_security_group_id = var.ec2_sg_id
}