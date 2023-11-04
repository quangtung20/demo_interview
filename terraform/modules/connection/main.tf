resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accpeter_vpc_id
  peer_region = var.accepter_region
  auto_accept = false
  provider    = aws.peer
  tags = {
    "Name" = "peering_connection"
  }
}

resource "aws_vpc_peering_connection_accepter" "this" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true
}

resource "aws_internet_gateway" "ig_requester" {
  provider = aws.peer
  vpc_id   = var.requester_vpc_id
  tags = {
    "Name" = "requester_ig"
  }
}

resource "aws_internet_gateway" "ig_accepter" {
  provider = aws.accepter
  vpc_id   = var.accpeter_vpc_id
  tags = {
    "Name" = "accepter_ig"
  }
}

resource "aws_route_table" "requester_route_table" {
  vpc_id   = var.requester_vpc_id
  provider = aws.peer
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_requester.id
  }
  tags = {
    "Name" = "peer_rtb"
  }
}

resource "aws_route_table" "accepter_route_table" {
  vpc_id   = var.accpeter_vpc_id
  provider = aws.accepter
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_accepter.id
  }
  tags = {
    "Name" = "accepter_rtb"
  }
}

resource "aws_route" "requester" {
  route_table_id            = aws_route_table.requester_route_table.id
  destination_cidr_block    = "13.0.4.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  provider                  = aws.peer
}

resource "aws_route" "accepter" {
  route_table_id            = aws_route_table.accepter_route_table.id
  destination_cidr_block    = "12.0.4.0/24"
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  provider                  = aws.accepter
}

resource "aws_route_table_association" "requester_association" {
  provider       = aws.peer
  subnet_id      = var.requester_subnet_id
  route_table_id = aws_route_table.requester_route_table.id
}

resource "aws_route_table_association" "accepter_association" {
  provider       = aws.accepter
  subnet_id      = var.accpeter_subnet_id
  route_table_id = aws_route_table.accepter_route_table.id
}


