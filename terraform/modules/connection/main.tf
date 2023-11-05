# create peering connection
resource "aws_vpc_peering_connection" "connection" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accpeter_vpc_id
  peer_region = var.accepter_region
  auto_accept = false
  provider    = aws.peer
  tags = {
    "Name" = "peering_connection"
  }
}

# accept connection
resource "aws_vpc_peering_connection_accepter" "connection_accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.connection.id
  auto_accept               = true
  tags = {
    "Name" = "peering_connection_accepter"
  }
}

# route tables
resource "aws_route" "requester" {
  provider                  = aws.peer
  route_table_id            = var.requester_route_table_id
  destination_cidr_block    = var.accpeter_subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.connection.id
}

resource "aws_route" "accepter" {
  provider                  = aws.accepter
  route_table_id            = var.accepter_route_table_id
  destination_cidr_block    = var.requester_subnet_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.connection.id

}


