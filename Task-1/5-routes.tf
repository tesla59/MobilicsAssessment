# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
  }

  tags = {
    Name = "Public Route table"
  }
}

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-gw-1.id
  }

  tags = {
    Name = "Private Route table 1"
  }
}

resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.test-gw-2.id
  }

  tags = {
    Name = "Private Route table 2"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.test-public-sg-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.test-public-sg-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.test-private-sg-1.id
  route_table_id = aws_route_table.private-1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.test-private-sg-2.id
  route_table_id = aws_route_table.private-2.id
}
