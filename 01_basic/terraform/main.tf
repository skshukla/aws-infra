provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc_1" {
  enable_dns_hostnames = true
  cidr_block           = var.vpc_cidr

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.subnets_cidr[1]
  availability_zone = var.subnets_azs[1]

  tags = {
    Name = "my_private_subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.subnets_cidr[0]
  availability_zone = var.subnets_azs[0]

  tags = {
    Name = "my_public_subnet"
  }
}

resource "aws_instance" "t2_3" {
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = var.key_pair_name
  instance_type               = var.instance_type
  associate_public_ip_address = true
  ami                         = var.ami_image

  tags = {
    Name = "ec2_public"
  }

  vpc_security_group_ids = [
    aws_security_group.allow_all_ingress_ports.id,
  ]
}

resource "aws_instance" "t2_4" {
  subnet_id                   = aws_subnet.private_subnet.id
  instance_type               = var.instance_type
  associate_public_ip_address = false
  ami                         = var.ami_image

  tags = {
    Name = "ec2_private"
  }

  vpc_security_group_ids = [
    aws_security_group.allow_all_ingress_ports.id,
  ]
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "my_igw"
  }
}

resource "aws_nat_gateway" "my_nat" {
  subnet_id     = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip.id

  tags = {
    Name = "my_nat"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    nat_gateway_id = aws_nat_gateway.my_nat.id
    cidr_block     = var.allow_all_cidr
  }

  tags = {
    Name = "rt_nat"
  }
}

resource "aws_route_table" "rt_igw" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    gateway_id = aws_internet_gateway.my_igw.id
    cidr_block = var.allow_all_cidr
  }

  tags = {
    Name = "rt_igw"
  }
}

resource "aws_route_table_association" "route_table_association_11" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt_igw.id
}

resource "aws_route_table_association" "route_table_association_12" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_eip" "nat_eip" {
  vpc  = true
  tags = merge(var.tags, {})
}

resource "aws_security_group" "allow_all_ingress_ports" {
  vpc_id = aws_vpc.vpc_1.id
  tags   = merge(var.tags, {})
  name   = "allow_all_ingress_ports"

  egress {
    to_port   = 0
    protocol  = "-1"
    from_port = 0
    cidr_blocks = [
      var.allow_all_cidr,
    ]
  }

  ingress {
    to_port   = 65535
    protocol  = "tcp"
    from_port = 0
    cidr_blocks = [
      var.allow_all_cidr,
    ]
  }
}

