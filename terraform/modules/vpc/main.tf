provider "aws" {
  alias  = "region"
  region = var.requester_region
}

resource "aws_vpc" "vpc" {
  provider             = aws.region
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  provider                = aws.region
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.public_subnet[count.index]
  availability_zone       = var.availability_zone[count.index]
  tags = {
    "Name" = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  provider                = aws.region
  count                   = length(var.private_subnet)
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = var.availability_zone[count.index]
  tags = {
    "Name" = "private-subnet"
  }
}

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

resource "aws_instance" "ec2-server" {
  provider                    = aws.region
  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = "interview"
  vpc_security_group_ids      = [aws_security_group.server-sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.private_subnet[0].id
  tags = {
    Name = "ec2-server"
  }
  user_data = <<-EOF
  #!/bin/bash
  yum update -y
  yum install -y httpd
  systemctl start httpd
  systemctl enable httpd
  echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
  EOF
}
