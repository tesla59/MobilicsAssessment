# NAT Gateways for Public and Private subnet
resource "aws_nat_gateway" "test-gw-1" {
  allocation_id = aws_eip.test-nat-1.id
  subnet_id     = aws_subnet.test-public-sg-1.id

  tags = {
    Name = "test NAT Gateway 1"
  }
}

resource "aws_nat_gateway" "test-gw-2" {
  allocation_id = aws_eip.test-nat-2.id
  subnet_id     = aws_subnet.test-public-sg-2.id

  tags = {
    Name = "test NAT Gateway 2"
  }
}

# Elastic IP Addresses
resource "aws_eip" "test-nat-1" {
  depends_on = [aws_internet_gateway.test-igw]
}

resource "aws_eip" "test-nat-2" {
  depends_on = [aws_internet_gateway.test-igw]
}
