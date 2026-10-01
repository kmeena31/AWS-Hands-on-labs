# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
     cidr_block = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${local.env}-rt-public"
  }
}

resource "aws_route_table_association" "public" { 
  count = length(local.public_subnets)

  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}