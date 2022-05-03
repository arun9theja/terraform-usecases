variable "customer_prefix" {
  type    = string
  default = "murlee-cnl"
}

variable "name" {
  type    = string
  default = "sample"
}

variable "VPC_NAME" {
  type    = string
  default = "nginx"
}

variable "base_region" {
  type    = string
  default = "us-east-1"
}

variable "az1" {
  description = "Availability zone 1"
  default     = "us-east-1a"
}

variable "az2" {
  description = "Availability zone 2"
  default     = "us-east-1b"
}

variable "ENV" {
  type    = string
  default = "test"
}

variable "container_image" {
  type    = string
  default = "nginx"
}

# variable "container_environment" {
#   type    = string
#   default = "test"
# }

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs used in Service `network_configuration` if `var.network_mode = \"awsvpc\"`"
  default     = null
}

variable "assign_public_ip" {
  description = "Whether this instance should be accessible from the public internet. Default is false."
  default     = true
  type        = bool
}

variable "network_mode" {
  type        = string
  description = "The network mode to use for the task. This is required to be `awsvpc` for `FARGATE` `launch_type` or `null` for `EC2` `launch_type`"
  default     = "awsvpc"
}
