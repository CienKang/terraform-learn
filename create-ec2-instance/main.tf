
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
provider "aws" {
  region = var.region
}

# for vpc, subnets, internet gateway, route table, route table association
resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "tf_vpc",
    Environment = "tf"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "Public Subnet ${count.index}",
    Environment = "tf"
  }
}

resource "aws_subnet" "tf_private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "Private Subnet ${count.index}",
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

resource "aws_route_table" "tf_route_table" {
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

resource "aws_route_table_association" "tf_rt_assoc" {
  count          = length(aws_subnet.tf_public_subnet)
  subnet_id      = aws_subnet.tf_public_subnet[count.index].id
  route_table_id = aws_route_table.tf_route_table.id
}


#  key pair and security group for ssh ec2
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "ssh_key_pair"
  public_key = file("./ssh_key_pair.pub")

  tags = {
    Name        = "ssh_key_pair",
    Environment = "tf"
  }
}


resource "aws_security_group" "tf-sg-ec2-ssh" {
  vpc_id = aws_vpc.tf_vpc.id
  name   = "tf-sg-ec2-ssh"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "tf-sg-ec2-ssh",
    Environment = "tf"
  }

}

# create an ec2 ubuntu instance
resource "aws_instance" "ec2-ssh-instance" {
  ami                         = var.ami-ec2-ssh
  instance_type               = var.ec2_instance_type
  key_name                    = aws_key_pair.ssh_key_pair.key_name
  subnet_id                   = aws_subnet.tf_public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.tf-sg-ec2-ssh.id]
  associate_public_ip_address = true

  provisioner "local-exec" {
    command = "echo ${aws_instance.ec2-ssh-instance.public_dns} > file.txt"
  }

  tags = {
    Name        = "ec2-ssh-instance",
    Environment = "tf"
  }
}
