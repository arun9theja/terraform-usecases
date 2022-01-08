variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = ""
}

variable "alb_sg_id" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = list(string)
}