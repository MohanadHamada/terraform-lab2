resource "aws_vpc" "tera_vpc" {
  cidr_block = var.cidr_block
  tags = {Name = "tera_vpc"}
}
data "aws_availability_zones" "available" {}
resource "aws_subnet" "subnet" {
  for_each = var.subnets
  vpc_id = aws_vpc.tera_vpc.id
  cidr_block = each.value
  map_public_ip_on_launch = each.key == "public" ? true : false
  availability_zone = data.aws_availability_zones.available.names[0] # us-east-1a
tags = {Name = each.key} 
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tera_vpc.id
  tags = {Name = "tera_igw"}
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.tera_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {Name = "public_rt"}
  depends_on = [ aws_internet_gateway.igw ,aws_subnet.subnet["public"] ]
}
resource "aws_main_route_table_association" "main" {
  vpc_id         = aws_vpc.tera_vpc.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public_rtassoc" {
  subnet_id      = aws_subnet.subnet["public"].id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_eip" "nat_eip" {
    domain = "vpc"
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id     = aws_subnet.subnet["public"].id
    depends_on    = [aws_internet_gateway.igw]
    tags = {
        Name = "tera_nat"
    }
}
resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.tera_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {Name = "private_rt"}
    depends_on = [ aws_nat_gateway.nat ,aws_subnet.subnet["private"] ]
}
resource "aws_route_table_association" "private_rtassoc" {
    subnet_id      = aws_subnet.subnet["private"].id
    route_table_id = aws_route_table.private_rt.id
}
resource "aws_security_group" "sec_group" {
  name   = "allow_ssh_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.tera_vpc.id
    ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tera_sec_group"
  }
}