module "dev" {
  source = "../modules"

  # Change 0 to 1 and open a pull request to trigger Terrateam
  null_resource_count = 2
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  region = "ap-southeast-2"
  alias = "engineer"
  profile = "engineer"
}

data "aws_caller_identity" "current" {}

data "aws_caller_identity" "engineer" {
  provider = aws.engineer
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "engineer_arn" {
  value = data.aws_caller_identity.engineer.arn
}

data "aws_s3_objects" "my_objects" {
  provider = aws.engineer
  bucket = "ztnie-airtasker-terraform-poc-backend"
}

output "object_keys" {
  value = data.aws_s3_objects.my_objects.keys
}
