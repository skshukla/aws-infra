# All variables as it would be defined in the .tfvars file.

ami_image          = "ami-0c7810c85aac7f1d5"
aws_region         = "ap-southeast-1"
bucket_name        = "sach-infra-tf-state"
create_instances   = true
deploy_igw_enabled = true
deploy_nat_enabled = true
deploy_tgw_enabled = true
deploy_vgw_enabled = true
instance_type      = "t2.micro"
instances_per_azs  = [0, 0, 0]
key_pair_name      = "sachin-aws-kp3"
subnets_azs        = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
subnets_cidr       = ["12.1.0.0/24", "12.1.1.0/24", "12.1.2.0/24"]
subnets_visibility = ["public", "private", "private"]
vpc_cidr           = "12.1.0.0/16"
