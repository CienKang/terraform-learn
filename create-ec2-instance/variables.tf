variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/20"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
}

variable "ami-ec2-ssh" {
  type        = string
  description = "AMI for EC2 instance"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
}
