provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent      = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  
  owners = ["099720109477"]
  
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = data.aws_ami.ubuntu.id
  
  tags = {
    Name = "ec2-${terraform.workspace}"
  }
  
}

## MANIPULANDO BUCKET S3

resource "aws_s3_bucket" "b" {
  bucket = "lab-fiap-75aoj-336959"
  acl    = "private"

  tags = {
    Name        = "lab-fiap-75aoj-336959"
    Environment = "admin"
  }
}

terraform {
  backend "s3" {
    bucket = "lab-fiap-75aoj-336959"
    key    = "ex-state-workspace"
    region = "us-east-1"
  }
}

## Workspace

locals {
  env = "${terraform.workspace}"

  // Isolate variables used for different workspaces
  // using map
  context = {
    default = {
      name = "arquivo-dev.txt"
    }
    dev = {
      name = "arquivo-dev.txt"
    }
    homol = {
      name = "arquivo-homol.txt"
    }
    prod = {
      name = "arquivo-prod.txt"
    }
  }

  context_variables = "${local.context[local.env]}"
}

// Creates a new local file with the given filename and content
resource "local_file" "test" {
  content     = "${local.env}"
  filename = "${lookup(local.context_variables, "name")}"
}