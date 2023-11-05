# create vpc 1 at region us-east-1
module "vpc1" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "12.0.0.0/16"
  public_subnet     = "12.0.1.0/24"
  private_subnet    = "12.0.4.0/24"
  availability_zone = "us-east-1a"
  requester_region  = "us-east-1"
  vpc_name          = "vpc1"
  ami               = "ami-05c13eab67c5d8861"
  providers = {
    aws = aws.requester
  }
}

# create vpc 2 at region us-west-1
module "vpc2" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "13.0.0.0/16"
  public_subnet     = "13.0.1.0/24"
  private_subnet    = "13.0.4.0/24"
  availability_zone = "us-west-1a"
  requester_region  = "us-west-1"
  vpc_name          = "vpc2"
  ami               = "ami-010f8b02680f80998"
  providers = {
    aws = aws.accepter
  }
}

# create connection between 2 vpcs
module "connection" {
  source                   = "./modules/connection"
  requester_region         = "us-east-1"
  accepter_region          = "us-west-1"
  requester_vpc_id         = module.vpc1.vpc_id
  accpeter_vpc_id          = module.vpc2.vpc_id
  requester_subnet_id      = module.vpc1.private_subnet.id
  accpeter_subnet_id       = module.vpc2.private_subnet.id
  requester_route_table_id = module.vpc1.route_table_id
  accepter_route_table_id  = module.vpc2.route_table_id
  requester_subnet_cidr    = "12.0.4.0/24"
  accpeter_subnet_cidr     = "13.0.4.0/24"
  providers = {
    aws.requester = aws.requester
    aws.accepter  = aws.accepter
  }
}


