resource "aws_vpc" "main" {
  # Limited the range of IP address to approximately 4000
  cidr_block           = "10.0.0.0/20"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks_vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true # Mapping public ip beacuse I want this to be pulic subnet
  depends_on              = [aws_internet_gateway.igwy]
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ca-central-1b"
  map_public_ip_on_launch = true # Mapping public ip beacuse I want this to be pulic subnet
  depends_on              = [aws_internet_gateway.igwy]
  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ca-central-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet2"
  }
}

resource "aws_internet_gateway" "igwy" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "eks-igw"
  }
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.internet_traffic #Route all internet traffic as this will be associated with public subnet
    gateway_id = aws_internet_gateway.igwy.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each = {
    "subnet1" = aws_subnet.public_subnet1.id
    "subnet2" = aws_subnet.public_subnet2.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.routetable.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet1.id # Placing it in public subnet 1
}

resource "aws_route_table" "private_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = var.internet_traffic
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_table.id
}

resource "aws_s3_bucket" "vpc_logs" {
  bucket = "vpc-logs-${random_id.bucket_suffix.hex}"
  tags = {
    Name = "VPC Flow Logs Bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

