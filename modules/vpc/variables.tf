variable "cidr_block" {
  type    = string
}

variable "azs" {
  type = list(string)
}

variable "public_subnet_id" {
  type = list(string)
}

variable "access_ip" {
  type = string
}
