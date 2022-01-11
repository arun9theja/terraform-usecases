variable "region" {
  description = "AWS Region us-east-1"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "access_ip" {
  type = string
}




