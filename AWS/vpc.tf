# Initialize the AWS provider
provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

# Create a default VPC
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an Internet Gateway
resource "aws_route_table_association" "public_subnet2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Create two public subnets
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Change availability zone as needed
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Change availability zone as needed
  map_public_ip_on_launch = true
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.default.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c" # Change availability zone as needed
}

# Create a public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
}

# Create a route to the Internet Gateway in the public route table
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Optionally, you can associate the public subnets with the public route table
resource "aws_route_table_association" "public_subnet1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}
