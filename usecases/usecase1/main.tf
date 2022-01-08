module "ec2" {
  source           = "../../modules/ec2"
  alb_sg_id        = module.alb.alb_sg_id
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  azs              = var.azs
}

module "alb" {
  source           = "../../modules/alb"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  instance_id      = module.ec2.instance_id
  ec2_sg_id        = module.ec2.ec2_sg_id
  azs              = var.azs
}

module "vpc" {
  source           = "../../modules/vpc"
  azs              = var.azs
  public_subnet_id = module.vpc.public_subnet_id
}


