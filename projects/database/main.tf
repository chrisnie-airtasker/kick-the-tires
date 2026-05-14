terraform {
  required_version = ">= 1.9.0, < 2.0.0"

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
    key                  = "database/terraform.tfstate"
    region               = "ap-southeast-2"
    workspace_key_prefix = "workspaces"
    profile              = "infra"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

locals {
  resource_count = terraform.workspace == "prod" ? 2 : 1
}

module "database" {
  source         = "../../modules"
  project_name   = "database"
  resource_count = local.resource_count
}

data "aws_caller_identity" "current" {}

output "workspace" {
  value = terraform.workspace
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "resource_ids" {
  value = module.database.resource_ids
}
