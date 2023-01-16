resource "aws_vpc" "vpc_2" {
  provider = aws.ap-southeast-1

  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "12.1.0.0/16"

  tags = {
    Name = "vpc_2"
  }
}

resource "aws_vpc" "vpc_0_c_c" {
  provider = aws.us-east-1

  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name = "vpc_0"
  }
}

resource "aws_vpc" "vpc_1" {
  provider = aws.ap-southeast-1

  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block           = "12.0.0.0/16"

  tags = {
    Name = "vpc_1"
  }
}

resource "aws_subnet" "sub_pub_vpc_1" {
  provider = aws.ap-southeast-1

  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "12.0.0.0/24"

  tags = {
    Name = "sub_pub_vpc_1"
  }
}

resource "aws_subnet" "sub_pub_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id     = aws_vpc.vpc_0_c_c.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "sub_pub_vpc_0"
  }
}

resource "aws_subnet" "sub_pub_vpc_2" {
  provider = aws.ap-southeast-1

  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "12.1.0.0/24"

  tags = {
    Name = "sub_pub_vpc_2"
  }
}

resource "aws_subnet" "sub_prv_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id     = aws_vpc.vpc_0_c_c.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sub_prv_vpc_0"
  }
}

resource "aws_subnet" "sub_prv_vpc_2" {
  provider = aws.ap-southeast-1

  vpc_id     = aws_vpc.vpc_2.id
  cidr_block = "12.1.1.0/24"

  tags = {
    Name = "sub_prv_vpc_2"
  }
}

resource "aws_subnet" "sub_prv_vpc_1" {
  provider = aws.ap-southeast-1

  vpc_id     = aws_vpc.vpc_1.id
  cidr_block = "12.0.1.0/24"

  tags = {
    Name = "sub_prv_vpc_1"
  }
}

resource "aws_internet_gateway" "igw_vpc_2" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_2.id
  tags   = merge(var.tags, {})
}

resource "aws_internet_gateway" "igw_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id = aws_vpc.vpc_0_c_c.id
  tags   = merge(var.tags, {})
}

resource "aws_internet_gateway" "igw_vpc_1" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_1.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table" "rt_igw_vpc_2" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_2.id
  tags   = { Name = "rt_igw_vpc_2" }

  route {
    gateway_id = aws_internet_gateway.igw_vpc_2.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table" "rt_igw_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id = aws_vpc.vpc_0_c_c.id
  tags   = { Name = "rt_igw_vpc_0" }

  route {
    gateway_id = aws_internet_gateway.igw_vpc_0_c_c.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table" "rt_igw_vpc_1" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_1.id
  tags   = { Name = "rt_igw_vpc_1" }

  route {
    gateway_id = aws_internet_gateway.igw_vpc_1.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table" "rt_nat_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id = aws_vpc.vpc_0_c_c.id
  tags   = { Name = "rt_ngw_vpc_0" }

  route {
    nat_gateway_id = aws_nat_gateway.nt_gw_vpc_0_c_c.id
    cidr_block     = "0.0.0.0/0"
  }
}

resource "aws_route_table" "rt_nat_vpc_1" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_1.id
  tags   = { Name = "rt_ngw_vpc_1" }

  route {
    nat_gateway_id = aws_nat_gateway.nt_gw_vpc_1.id
    cidr_block     = "0.0.0.0/0"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "12.1.0.0/16"
  }
}

resource "aws_route_table" "rt_nat_vpc_2" {
  provider = aws.ap-southeast-1

  vpc_id = aws_vpc.vpc_2.id
  tags   = { Name = "rt_ngw_vpc_2" }

  route {
    nat_gateway_id = aws_nat_gateway.nt_gw_vpc_2.id
    cidr_block     = "0.0.0.0/0"
  }
  route {
    transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
    cidr_block         = "12.0.0.0/16"
  }
}

resource "aws_route_table_association" "rt_nat_association_vpc_0_c_c" {
  provider = aws.us-east-1

  subnet_id      = aws_subnet.sub_prv_vpc_0_c_c.id
  route_table_id = aws_route_table.rt_nat_vpc_0_c_c.id
}

resource "aws_route_table_association" "rt_nat_association_vpc_1" {
  provider = aws.ap-southeast-1

  subnet_id      = aws_subnet.sub_prv_vpc_1.id
  route_table_id = aws_route_table.rt_nat_vpc_1.id
}

resource "aws_route_table_association" "rt_nat_association_vpc_2" {
  provider = aws.ap-southeast-1

  subnet_id      = aws_subnet.sub_prv_vpc_2.id
  route_table_id = aws_route_table.rt_nat_vpc_2.id
}

resource "aws_nat_gateway" "nt_gw_vpc_0_c_c" {
  provider = aws.us-east-1

  subnet_id     = aws_subnet.sub_pub_vpc_0_c_c.id
  allocation_id = aws_eip.eip_vpc_0_c_c.id

  tags = {
    Name = "nt_gw_vpc_0"
  }
}

resource "aws_nat_gateway" "nt_gw_vpc_1" {
  provider = aws.ap-southeast-1

  tags          = merge(var.tags, {})
  subnet_id     = aws_subnet.sub_pub_vpc_1.id
  allocation_id = aws_eip.eip_vpc_1.id
}

resource "aws_nat_gateway" "nt_gw_vpc_2" {
  provider = aws.ap-southeast-1

  subnet_id     = aws_subnet.sub_pub_vpc_2.id
  allocation_id = aws_eip.eip_vpc_2.id

  tags = {
    Name = "ngw_vpc_2"
  }
}

resource "aws_eip" "eip_vpc_2" {
  provider = aws.ap-southeast-1

  tags = { Name = "eip_vpc_2" }
}

resource "aws_eip" "eip_vpc_0_c_c" {
  provider = aws.us-east-1

  tags = merge(var.tags, {})
}

resource "aws_eip" "eip_vpc_1" {
  provider = aws.ap-southeast-1


  tags = {
    Name = "eip_vpc_1"
  }
}

resource "aws_instance" "ec2_vpc_1_sub_prv" {
  provider = aws.ap-southeast-1

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

resource "aws_instance" "ec2_vpc_2_sub_prv_c_c" {
  provider = aws.ap-southeast-1

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

resource "aws_instance" "ec2_vpc_0_sub_prv_c_c" {
  provider = aws.us-east-1

  subnet_id     = aws_subnet.sub_prv_vpc_0_c_c.id
  key_name      = var.key_pair_name
  instance_type = "t2.micro"
  ami           = "ami-02de7ddd349689b89"

  security_groups = [
    aws_security_group.sg_vpc_0_c_c.id,
  ]

  tags = {
    Name = "ec2_vpc_0_sub_prv"
  }
}

resource "aws_instance" "ec2_vpc_0_sub_pub_c_c" {
  provider = aws.us-east-1

  subnet_id                   = aws_subnet.sub_pub_vpc_0_c_c.id
  key_name                    = var.key_pair_name
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ami                         = "ami-02de7ddd349689b89"

  security_groups = [
    aws_security_group.sg_vpc_0_c_c.id,
  ]

  tags = {
    Name = "ec2_vpc_0_sub_pub"
  }
}

resource "aws_instance" "ec2_vpc_2_sub_pub_c_c" {
  provider = aws.ap-southeast-1

  subnet_id                   = aws_subnet.sub_pub_vpc_2.id
  key_name                    = var.key_pair_name
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  ami                         = var.ami_image

  security_groups = [
    aws_security_group.sg_vpc_2.id,
  ]

  tags = {
    Name = "ec2_vpc_2_sub_pub"
  }
}

resource "aws_instance" "ec2_vpc_1_sub_pub" {
  provider = aws.ap-southeast-1

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
  provider = aws.ap-southeast-1

  subnet_id      = aws_subnet.sub_pub_vpc_1.id
  route_table_id = aws_route_table.rt_igw_vpc_1.id
}

resource "aws_route_table_association" "rt_igw_association_vpc_2" {
  provider = aws.ap-southeast-1

  subnet_id      = aws_subnet.sub_pub_vpc_2.id
  route_table_id = aws_route_table.rt_igw_vpc_2.id
}

resource "aws_route_table_association" "rt_igw_association_vpc_0_c_c" {
  provider = aws.us-east-1

  subnet_id      = aws_subnet.sub_pub_vpc_0_c_c.id
  route_table_id = aws_route_table.rt_igw_vpc_0_c_c.id
}

resource "aws_security_group" "sg_vpc_0_c_c" {
  provider = aws.us-east-1

  vpc_id = aws_vpc.vpc_0_c_c.id
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
  provider = aws.ap-southeast-1

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
  provider = aws.ap-southeast-1

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
  provider = aws.ap-southeast-1


  tags = {
    Name = "tgw_sg"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_sg_attachment2" {
  provider = aws.ap-southeast-1

  vpc_id             = aws_vpc.vpc_2.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_2.id,
  ]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_sg_attachment" {
  provider = aws.ap-southeast-1

  vpc_id             = aws_vpc.vpc_1.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_sg.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_1.id,
  ]
}

resource "aws_ec2_transit_gateway" "tgw_us_east_1_c_c" {
  provider = aws.us-east-1

  tags = merge(var.tags, {})
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_us_east-1_c_c" {
  provider = aws.us-east-1

  vpc_id             = aws_vpc.vpc_0_c_c.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east_1_c_c.id
  tags               = merge(var.tags, {})

  subnet_ids = [
    aws_subnet.sub_prv_vpc_0_c_c.id,
  ]
}

resource "aws_ec2_transit_gateway_peering_attachment" "tgw_peer_attach" {
  provider = aws.ap-southeast-1

  transit_gateway_id      = aws_ec2_transit_gateway.tgw_sg.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_us_east_1_c_c.id
  peer_region             = "us-east-1"

  tags = {
    Name = "tgw_peer_attach"
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "tgw_peer_attach_accept" {
  provider = aws.us-east-1

  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.tgw_peer_attach.id

  tags = {
    Name = "tgw_peer_attach_accept"
  }
}

