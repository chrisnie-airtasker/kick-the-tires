terraform {
  required_version = ">= 1.6.0, < 1.7.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket               = "ztnie-airtasker-terraform-poc-backend"
    key                  = "compute/terraform.tfstate"
    region               = "ap-southeast-2"
    workspace_key_prefix = "workspaces"
    profile              = "infra"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  region = "ap-southeast-2"
  profile = "engineer"
  alias = "engineer"
}

locals {
  resource_count = terraform.workspace == "prod" ? 4 : 2
}

module "compute" {
  source         = "../../modules"
  project_name   = "compute"
  resource_count = local.resource_count
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  count         = terraform.workspace == "prod" ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_caller_identity" "current" {}

output "workspace" {
  value = terraform.workspace
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "resource_ids" {
  value = module.compute.resource_ids
}
