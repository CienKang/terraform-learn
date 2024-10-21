terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"
  subnet_id     = "subnet-06089dda40904869d"
  # subnet_id needs to given as there is no default vpc option in my account.

  # execute this command after creating the instance on the machine that runs the terraform script
  provisioner "local-exec" {
    command = "echo ${self.id} ${self.public_ip} ${self.private_ip} ${self.instance_type} >> file.txt"
  }

  tags = {
    Name = "tf-practise-app-server"
  }
}
