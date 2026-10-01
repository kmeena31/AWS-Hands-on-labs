# Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.env}-public"
  }
}

# ==========================================================
# STEP 4.1 - ADD INTERNET ROUTE
# Destination: 0.0.0.0/0
# Target: MyIGW
# ==========================================================

resource "aws_route_table_association" "public" { 
  count = length(local.public_subnets)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id


}