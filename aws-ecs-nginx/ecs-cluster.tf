# ECS cluster
resource "aws_ecs_cluster" "sample_cluster" {
  name = "cnl_demo_cluster"
}

# Security groups
resource "aws_security_group" "test_ecs_sg" {
  name        = "${var.customer_prefix}-${var.ENV}-ecs-sg"
  description = "To allow traffic from/to loadbalancer"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.test_alb_sg.id]
  }

  egress {
    description = "Allow egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "test_alb_sg" {
  name        = "${var.customer_prefix}-${var.ENV}-alb-sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "alb_ecs_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.test_alb_sg.id
  source_security_group_id = aws_security_group.test_ecs_sg.id
}

# ECS Task Definition
resource "aws_ecs_task_definition" "test_td" {
  family                   = "test"
  network_mode             = var.network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "${var.customer_prefix}-${var.ENV}-nginx-container"
    image     = "${var.container_image}:latest"
    essential = true
    # environment = var.container_environment
    portMappings = [{
      protocol      = "tcp"
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# ECS task role for S3
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecsTaskRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "s3_access" {
  name        = "${var.name}-task-policy-s3"
  description = "Policy that allows access to S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::test"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::test/*"]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# ECS task execution role for Fargate(Serverless)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.name}-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Service
resource "aws_ecs_service" "test_service" {
  name                               = "${var.name}-service-${var.ENV}"
  cluster                            = aws_ecs_cluster.sample_cluster.id
  task_definition                    = aws_ecs_task_definition.test_td.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  load_balancer {
    target_group_arn = aws_alb_target_group.test_lb_tg.arn
    container_name   = "${var.customer_prefix}-${var.ENV}-nginx-container"
    container_port   = 80
  }

  network_configuration {
    subnets          = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}"]
    security_groups  = [aws_security_group.test_ecs_sg.id]
    assign_public_ip = var.assign_public_ip
  }
}

# Application Loadbalancer
resource "aws_lb" "test_alb" {
  name               = "${var.customer_prefix}-${var.ENV}-nginx-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_alb_sg.id]
  subnets            = ["${aws_subnet.public-subnet-1.id}", "${aws_subnet.public-subnet-2.id}"]

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "test_lb_tg" {
  name        = "${var.customer_prefix}-${var.ENV}-nginx-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/healthz"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.test_alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test_lb_tg.arn

  }
}

