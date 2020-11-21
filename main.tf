terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.16"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "us-east-1"
}

resource "aws_instance" "web" {
  ami = "ami-02354e95b39ca8dec"
  instance_type = "t2.small"
  disable_api_termination = true
  tags = {
    "Name" = "manitoba_ryder_cup"
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  vpc = true
  tags = {
    "Name" = "manitoba_ryder_cup"
  }
}

resource "tls_private_key" "admin_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "admin" {
  key_name = "admin-key"
  public_key = tls_private_key.admin_key.public_key_openssh
  tags = {
    "Name" = "manitoba_ryder_cup"
  }
}
