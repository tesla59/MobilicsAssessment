# Public Subnets
resource "aws_subnet" "test-public-sg-1" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.0.0/18"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "test-public-sg-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.64.0/18"
  availability_zone = "ap-south-1b"
}

# Private subnets
resource "aws_subnet" "test-private-sg-1" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.192.0/18"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "test-private-sg-2" {
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = "10.0.128.0/18"
  availability_zone = "ap-south-1b"
}
