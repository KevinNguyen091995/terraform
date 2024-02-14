# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

# Subnets
resource "aws_subnet" "private_us_east_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-2a"

  tags = {
    "Name" = "private-us-east-2a"
  }
}

resource "aws_subnet" "private_us_east_2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-2b"

  tags = {
    "Name" = "private-us-east-2b"
  }
}

resource "aws_subnet" "public_us_east_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-2a"
  }
}

resource "aws_subnet" "public_us_east_2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-us-east-2b"
  }
}

# NAT
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_us_east_2a.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

# Routes
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "private_us_east_2a" {
  subnet_id      = aws_subnet.private_us_east_2a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_us_east_2b" {
  subnet_id      = aws_subnet.private_us_east_2b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public_us_east_2a" {
  subnet_id      = aws_subnet.public_us_east_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_us_east_2b" {
  subnet_id      = aws_subnet.public_us_east_2b.id
  route_table_id = aws_route_table.public.id
}