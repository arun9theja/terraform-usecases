module "ec2" {
  source           = "../../modules/ec2"
  instance_type    = "t3.micro"
  ami              = ""
  access_ip        = "0.0.0.0/0"
  azs              = var.azs
  alb_sg_id        = module.alb.alb_sg_id
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
}

module "alb" {
  source                 = "../../modules/alb"
  ec2_count              = 2
  access_ip              = "0.0.0.0/0"
  tg_port                = 80
  tg_protocol            = "HTTP"
  lb_healthy_threshold   = 2
  lb_unhealthy_threshold = 2
  timeout                = 3
  interval               = 30
  listener_port          = 80
  listener_protocol      = "HTTP"
  vpc_id                 = module.vpc.vpc_id
  public_subnet_id       = module.vpc.public_subnet_id
  instance_id            = module.ec2.instance_id
  ec2_sg_id              = module.ec2.ec2_sg_id
  azs                    = var.azs
}

module "vpc" {
  source           = "../../modules/vpc"
  cidr_block       = "10.0.0.0/16"
  access_ip        = "0.0.0.0/0"
  azs              = var.azs
  public_subnet_id = module.vpc.public_subnet_id
}


