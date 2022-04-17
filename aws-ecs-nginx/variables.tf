variable "customer_prefix" {
  type    = string
  default = "murlee"
}

variable "name" {
  type    = string
  default = "sample"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "base_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "environment" {
  type    = string
  default = "sandpit"
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
