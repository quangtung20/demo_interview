module "vpc1" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "12.0.0.0/16"
  public_subnet     = ["12.0.1.0/24"]
  private_subnet    = ["12.0.4.0/24"]
  availability_zone = ["us-east-1a"]
  requester_region  = "us-east-1"
  vpc_name          = "vpc1"
  ami               = "ami-05c13eab67c5d8861"
}

module "vpc2" {
  source            = "./modules/vpc"
  vpc_cidr_block    = "13.0.0.0/16"
  public_subnet     = ["13.0.1.0/24"]
  private_subnet    = ["13.0.4.0/24"]
  availability_zone = ["us-west-1a"]
  requester_region  = "us-west-1"
  vpc_name          = "vpc2"
  ami               = "ami-010f8b02680f80998"
}

module "connection" {
  source              = "./modules/connection"
  requester_region    = "us-east-1"
  accepter_region     = "us-west-1"
  requester_vpc_id    = module.vpc1.vpc_id
  accpeter_vpc_id     = module.vpc2.vpc_id
  requester_subnet_id = module.vpc1.private_subnet[0].id
  accpeter_subnet_id  = module.vpc2.private_subnet[0].id
}


