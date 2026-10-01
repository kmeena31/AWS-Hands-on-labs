#step 2: Create public subnet
resource "aws_subnet" "public" {
    count = length(local.public_subnets)

    vpc_id                  = aws_vpc.my_vpc.id 
    cidr_block              = local.public_subnets[count.index]
    availablity_zone        = local.azs[count.index]
    map_public_ip_on_launch = true

     tags = {
        Name = "${local.env}-public-${local.azs[count.index]}"
     }
}