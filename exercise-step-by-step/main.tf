provider "aws" {
  region = var.aws_region
}

# 1. Basic VPC Setup
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.vpc_tags
}

resource "aws_subnet" "tf_public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "Public Subnet ${count.index + 1}",
    Environment = "tf"
  }
}


resource "aws_subnet" "tf_private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "Private Subnet ${count.index + 1}",
    Environment = "tf"
  }

}

resource "aws_internet_gateway" "tf_ig" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name        = "tf_ig",
    Environment = "tf"
  }
}

resource "aws_route_table" "tf_public_route_table" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_ig.id
  }

  tags = {
    Name        = "tf_route_table",
    Environment = "tf"
  }
}

resource "aws_route_table" "tf_private_route_table" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name        = "tf_private_route_table",
    Environment = "tf"
  }
}

resource "aws_route_table_association" "tf_public_rt_assoc" {
  count          = length(aws_subnet.tf_public_subnet)
  subnet_id      = aws_subnet.tf_public_subnet[count.index].id
  route_table_id = aws_route_table.tf_public_route_table.id
}

resource "aws_route_table_association" "tf_private_rt_assoc" {
  count          = length(aws_subnet.tf_private_subnet)
  subnet_id      = aws_subnet.tf_private_subnet[count.index].id
  route_table_id = aws_route_table.tf_private_route_table.id
}

# 2. Add Networking Components

# Creating an elastic IP address to use for the NAT Gateway, then create a NAT Gateway in the public subnet and associate the EIP with it.
resource "aws_eip" "tf_public_nat_ip" {
  vpc = true
  tags = {
    Name        = "tf_public_nat_ip",
    Environment = "tf"
  }
}

resource "aws_nat_gateway" "tf_public_nat_gw" {
  allocation_id = aws_eip.tf_public_nat_ip.id
  subnet_id     = aws_subnet.tf_public_subnet[0].id

  depends_on = [aws_eip.tf_public_nat_ip, aws_subnet.tf_public_subnet]
  tags = {
    Name        = "tf_public_nat_gw",
    Environment = "tf"
  }
}

# Create a route in the private route table that sends all traffic to the NAT Gateway.
resource "aws_route" "tf_private_route_nat_gw" {
  route_table_id         = aws_route_table.tf_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.tf_public_nat_gw
}

resource "aws_security_group" "tf_public_subnet_sg" {
  name   = "tf_public_subnet_sg"
  vpc_id = aws_vpc.tf_vpc.id

}
