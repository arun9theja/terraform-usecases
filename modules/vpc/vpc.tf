resource "aws_vpc" "test-vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "test"
  }
}

resource "aws_subnet" "public" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.test-vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = var.azs[count.index]
  tags = {
    Name = "Public Subnet - ${element(var.azs, count.index)}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = var.access_ip
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "main"
  }
}

resource "aws_route_table_association" "rt-assoc" {
  count          = length(var.public_subnet_id)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.route-table.id
}