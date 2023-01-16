variable "deploy_nat_enabled" {
  type = bool
}

variable "create_instances" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "bucket_name" {
  type = string
}

variable "deploy_igw_enabled" {
  type = bool
}

variable "subnets_visibility" {
  type = list(string)
}

variable "instances_per_azs" {
  type = list(number)
}

variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "subnets_cidr" {
  type = list(string)
}

variable "ami_image" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "subnets_azs" {
  type = list(string)
}

variable "deploy_vgw_enabled" {
  type = bool
}

variable "deploy_tgw_enabled" {
  type = bool
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "d2393917-1e63-40fd-8ba0-7f0ac031aa6a"
    env      = "Development"
  }
}

