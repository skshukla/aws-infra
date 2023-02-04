variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "ami_image" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "bucket_name" {
  type = string
}

variable "create_instances" {
  type = bool
}

variable "deploy_igw_enabled" {
  type = bool
}

variable "deploy_nat_enabled" {
  type = bool
}

variable "deploy_tgw_enabled" {
  type = bool
}

variable "deploy_vgw_enabled" {
  type = bool
}

variable "instance_type" {
  type = string
}

variable "instances_per_azs" {
  type = list(number)
}

variable "key_pair_name" {
  type = string
}

variable "subnets_azs" {
  type = list(string)
}

variable "subnets_cidr" {
  type = list(string)
}

variable "subnets_visibility" {
  type = list(string)
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "0d878f3c-8b0b-481e-9ed4-67f452d89e88"
    env      = "Development"
  }
}

variable "vpc_cidr" {
  type = string
}

