variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
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

variable "access_ip" {
  type = string
}