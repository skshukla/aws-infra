# All variables as it would be defined in the .tfvars file.

deploy_nat_enabled = true
create_instances   = true
instance_type      = "t2.micro"
vpc_cidr           = "12.1.0.0/16"
aws_region         = "ap-southeast-1"
bucket_name        = "sach-infra-tf-state"
deploy_igw_enabled = true
subnets_visibility = ["public", "private", "private"]
instances_per_azs  = [0, 0, 0]
subnets_cidr       = ["12.1.0.0/24", "12.1.1.0/24", "12.1.2.0/24"]
ami_image          = "ami-0a3008e4c99490c4e"
key_pair_name      = "sachin-aws-kp3"
subnets_azs        = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
deploy_vgw_enabled = true
deploy_tgw_enabled = true
