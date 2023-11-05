## backend
terraform {
  backend "s3" {
    bucket         = "s3statebackend051123tung"
    dynamodb_table = "state-lock"
    key            = "global/mystatefile/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

## requester
provider "aws" {
  alias  = "requester"
  region = "us-east-1"
}

## accepter 
provider "aws" {
  alias  = "accepter"
  region = "us-west-1"
}
