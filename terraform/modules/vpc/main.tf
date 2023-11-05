# create vpc
resource "aws_vpc" "vpc" {
  provider             = aws.region
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc.id
  tags = {
    "Name" = "internet_gateway"
  }
}

resource "aws_route_table" "peer_route_table" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "peer_rtb"
  }
}

resource "aws_subnet" "public_subnet" {
  provider                = aws.region
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet
  availability_zone       = var.availability_zone
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  provider                = aws.region
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.private_subnet
  availability_zone       = var.availability_zone
  tags = {
    "Name" = "private-subnet"
  }
}

# associate only private subnet, connecting private subnet with igw to easily connect to EC2 instance
resource "aws_route_table_association" "peer_association" {
  provider       = aws.region
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.peer_route_table.id
}

# create security group for instance
resource "aws_security_group" "server-sg" {
  provider    = aws.region
  name        = "server-sg"
  description = "security group server"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

# create ec2 instance
resource "aws_instance" "ec2-server" {
  provider                    = aws.region
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = "interview"
  vpc_security_group_ids      = [aws_security_group.server-sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet.id
  tags = {
    Name = "ec2-server"
  }
  user_data = file("C:/Users/tranq/OneDrive/Documents/project/interview_everfit/terraform/modules/vpc/entry-script.sh")
}
