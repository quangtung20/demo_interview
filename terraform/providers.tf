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
