terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.aws_key)
}

resource "aws_security_group" "lux" {
  name        = "lux"
  description = "allow ssh and http traffic"

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "ssh"
      from_port        = 22
      protocol         = "tcp"
      to_port          = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "http"
      from_port        = 80
      protocol         = "tcp"
      to_port          = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {

      description      = "https"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "out"
      from_port        = 0
      protocol         = "-1"
      to_port          = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}

resource "aws_instance" "app_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  count           = 2
  security_groups = ["${aws_security_group.lux.name}"]
  key_name        = aws_key_pair.deployer.key_name

  tags = {
    Name = var.instance_name
  }
}
