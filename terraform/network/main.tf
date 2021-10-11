# --- Networking/main.tf ---

data "aws_availability_zones" "availability" {
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.availability.names
  result_count = var.max_subnets
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "tp_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "tp_vpc-${random_integer.random.id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# --- creates the public subnet for the aws network --- #

resource "aws_subnet" "tp_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.tp_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "tp_public_${count.index + 1}"
  }
}

# --- creates the private subnet for the aws network --- #

resource "aws_subnet" "tp_private_subnet" {
  count                   = var.private_sn_count
  vpc_id                  = aws_vpc.tp_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "tp_private_${count.index + 1}"
  }
}

# --- creating route table for the VPC --- #

resource "aws_route_table_association" "tp_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.tp_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.tp_public_rt.id
}

# --- creating gateway so that it can access the outside internet --- #

resource "aws_internet_gateway" "tp_internet_gateway" {
  vpc_id = aws_vpc.tp_vpc.id

  tags = {
    Name = "tp_igw"
  }
}


resource "aws_route_table" "tp_public_rt" {
  vpc_id = aws_vpc.tp_vpc.id
  tags = {
    Name = "tp_public"
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.tp_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tp_internet_gateway.id

}

resource "aws_default_route_table" "tp_private_rt" {
  default_route_table_id = aws_vpc.tp_vpc.default_route_table_id
  

  tags = {
    Name = "tp_private"
  }
}

# --- creating security group to filter services --- #

resource "aws_security_group" "tp_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.tp_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {

      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tp-sg"
  }
}
