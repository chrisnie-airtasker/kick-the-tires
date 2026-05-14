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

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
