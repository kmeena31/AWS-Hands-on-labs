
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
#step 3: Create internet gateway  & below code attach to vpc 
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyIGW"
  }
}

#step 4: Create public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "PublicRouteTable"
  }
}

# ==========================================================
# STEP 4.1 - ADD INTERNET ROUTE
# Destination: 0.0.0.0/0
# Target: MyIGW
# ==========================================================

resource "aws_route" "public_internet_route" { 
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
}

# ==========================================================
# STEP 4.2 - ASSOCIATE PUBLIC SUBNET
# WITH PUBLIC ROUTE TABLE
# ==========================================================

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}
