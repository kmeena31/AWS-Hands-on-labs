#step 3: Create internet gateway  & below code attach to vpc 
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${local.env}-igw"
  }
}