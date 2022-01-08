variable "ec2_count" {
  type    = number
  default = 2
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