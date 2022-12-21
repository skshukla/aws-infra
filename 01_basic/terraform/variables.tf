variable "vpc_cidr" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}

variable "deploy_igw_enabled" {
  type = bool
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(any)
  default = {
    archuuid = "b2e7733d-a9dd-4a39-b0bb-aac33ec75b31"
    env      = "Development"
  }
}

variable "subnets_azs" {
  type = list(string)
}

variable "allow_all_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "bucket_name" {
  type = string
}

variable "deploy_nat_enabled" {
  type = bool
}

variable "deploy_tgw_enabled" {
  type = bool
}

variable "instances_per_azs" {
  type = list(number)
}

variable "subnets_visibility" {
  type = list(string)
}

variable "key_pair_name" {
  type = string
}

variable "subnets_cidr" {
  type = list(string)
}

variable "ami_image" {
  type = string
}

variable "deploy_vgw_enabled" {
  type = bool
}

variable "create_instances" {
  type = bool
}

variable "instance_type" {
  type = string
}

