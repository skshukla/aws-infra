terraform {
  required_providers {
    aws = {
      version = "= 4.48.0"
    }
  }
}
provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "vpc_3_c" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.3.0.0/16"

  tags = {
    Name = "vpc_3"
  }
}

resource "aws_vpc" "vpc_2" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.2.0.0/16"

  tags = {
    Name = "vpc_2"
  }
}

resource "aws_vpc" "vpc_1" {
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.1.0.0/16"

  tags = {
    Name = "vpc_1"
  }
}

resource "aws_subnet" "sub_pub_vpc_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "sub_pub_vpc_1"
  }
}

resource "aws_subnet" "sub_prv_vpc_3_c" {
  vpc_id     = aws_vpc.vpc_3_c.id
  cidr_block = "10.3.1.0/24"

  tags = {
    Name = "sub_prv_vpc_3"
  }
}

resource "aws_subnet" "sub_prv_vpc_2" {
  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "10.2.1.0/24"

  tags = {
    Name = "sub_prv_vpc_2"
  }
}

resource "aws_subnet" "sub_prv_vpc_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "sub_prv_vpc_1"
  }
}

resource "aws_internet_gateway" "igw_vpc_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_igw_vpc_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags   = { Name = "rt_igw_vpc_1" }

  route {
    gateway_id = aws_internet_gateway.igw_vpc_1.id
    cidr_block = "0.0.0.0/0"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "10.2.0.0/16"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "10.3.0.0/16"
  }
}

resource "aws_route_table" "rt_nat_vpc_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags   = { Name = "rt_ngw_vpc_1" }

  route {
    nat_gateway_id = aws_nat_gateway.nt_gw_vpc_1.id
    cidr_block     = "0.0.0.0/0"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "10.2.0.0/16"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "10.3.0.0/16"
  }
}

resource "aws_route_table" "rt_vpc_3" {
  vpc_id = aws_vpc.vpc_3_c.id
  tags   = { Name = "rt_vpc_3" }

  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "0.0.0.0/0"
  }
}

resource "aws_route_table" "rt_vpc_2" {
  vpc_id = aws_vpc.vpc_2.id
  tags   = { Name = "rt_vpc_2" }

  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "rt_nat_association_vpc_2" {
  subnet_id      = aws_subnet.sub_prv_vpc_2.id
  route_table_id = aws_route_table.rt_vpc_2.id
}

resource "aws_route_table_association" "rt_nat_association_vpc_1" {
  subnet_id      = aws_subnet.sub_prv_vpc_1.id
  route_table_id = aws_route_table.rt_nat_vpc_1.id
}

resource "aws_route_table_association" "rt_nat_association_vpc_3" {
  subnet_id      = aws_subnet.sub_prv_vpc_3_c.id
  route_table_id = aws_route_table.rt_vpc_3.id
}

resource "aws_nat_gateway" "nt_gw_vpc_1" {
  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.sub_pub_vpc_1.id
  allocation_id = aws_eip.eip_vpc_1.id
}

resource "aws_eip" "eip_vpc_1" {

  tags = {
    Name = "eip_vpc_1"
  }
}

resource "aws_instance" "ec2_vpc_2_sub_prv_c_c" {
  subnet_id     = aws_subnet.sub_prv_vpc_2.id
  key_name      = var.key_pair_name
  instance_type = "t2.micro"
  ami           = var.ami_image

  security_groups = [
    aws_security_group.sg_vpc_2.id,
  ]

  tags = {
    Name = "ec2_vpc_2_sub_prv"
  }
}

resource "aws_instance" "ec2_vpc_1_sub_prv" {
  subnet_id     = aws_subnet.sub_prv_vpc_1.id
  key_name      = var.key_pair_name
  instance_type = "t2.micro"
  ami           = var.ami_image

  security_groups = [
    aws_security_group.sg_vpc_1.id,
  ]

  tags = {
    Name = "ec2_vpc_1_sub_prv"
  }
}

resource "aws_instance" "ec2_vpc_3_sub_prv" {
  subnet_id     = aws_subnet.sub_prv_vpc_3_c.id
  key_name      = var.key_pair_name
  instance_type = "t2.micro"
  ami           = var.ami_image

  security_groups = [
    aws_security_group.sg_vpc_3.id,
  ]

  tags = {
    Name = "ec2_vpc_3_sub_prv"
  }
}

resource "aws_instance" "ec2_vpc_1_sub_pub" {
  subnet_id                   = aws_subnet.sub_pub_vpc_1.id
  key_name                    = var.key_pair_name
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ami                         = var.ami_image

  security_groups = [
    aws_security_group.sg_vpc_1.id,
  ]

  tags = {
    Name = "ec2_vpc_1_sub_pub"
  }
}

resource "aws_route_table_association" "rt_igw_association_vpc_1" {
  subnet_id      = aws_subnet.sub_pub_vpc_1.id
  route_table_id = aws_route_table.rt_igw_vpc_1.id
}

resource "aws_security_group" "sg_vpc_3" {
  vpc_id = aws_vpc.vpc_3_c.id
  tags   = merge(var.tags, {})

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 65535
    protocol  = "tcp"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "sg_vpc_2" {
  vpc_id = aws_vpc.vpc_2.id
  tags   = merge(var.tags, {})

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 65535
    protocol  = "tcp"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_security_group" "sg_vpc_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags   = merge(var.tags, {})

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  ingress {
    to_port   = 65535
    protocol  = "tcp"
    from_port = 0
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}

resource "aws_ec2_transit_gateway" "tgw_sg" {

  tags = {
    Name = "tgw_sg"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_sg_attachment" {
  vpc_id             = aws_vpc.vpc_1.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_1.id,
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_sg_attachment3" {
  vpc_id             = aws_vpc.vpc_3_c.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_3_c.id,
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_sg_attachment2" {
  vpc_id             = aws_vpc.vpc_2.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_2.id,
  ]
}

