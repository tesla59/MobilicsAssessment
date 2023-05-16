# Internet Gateway
resource "aws_internet_gateway" "test-igw" {
  vpc_id     = aws_vpc.test-vpc.id
  depends_on = [aws_vpc.test-vpc]

  tags = {
    "Name" = "test-igw"
  }
}
