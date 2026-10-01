
#step 1: Create VPC
resource "aws_vpc" "my_vpc"{

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "MyVPC"
    }
}

#step 2: Create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.my_vpc.id 
    cidr_block = "10.0.0.0/24"
     # Auto-assign public IPv4 address = Enable
     map_public_ip_on_launch = true

     tags = {
        Name = "MyPublicSubnet"
     }
}
# step 2.1 Create private subnet 
resource "aws_subnet" "private_subnet" { 
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  # Private instances should NOT automatically receive
  # public IP addresses.
  map_public_ip_on_launch = false
  tags = {
    Name = "MyPrivateSubnet"
  }
}