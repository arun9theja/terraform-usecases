variable "ec2_count" {
  type = number
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}

variable "instance_id" {
  type = list(string)
}

variable "ec2_sg_id" {
  type = string
}

variable "access_ip" {
  type = string
}

variable "tg_port" {}
variable "tg_protocol" {}
variable "lb_healthy_threshold" {}
variable "lb_unhealthy_threshold" {}
variable "timeout" {}
variable "interval" {}
variable "listener_port" {}
variable "listener_protocol" {}