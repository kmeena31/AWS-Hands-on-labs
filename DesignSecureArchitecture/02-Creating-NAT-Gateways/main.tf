
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

# ==========================================================
# AMAZON LINUX 2023 AMI
#
# Automatically obtains the latest Amazon Linux 2023
# x86_64 AMI from AWS Systems Manager Parameter Store.
# ==========================================================

data "aws_ssm_parameter" "amazon_linux_2023" {

  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}


# ==========================================================
# CREATE SSH KEY PAIR
#
# AWS Key Pair Name:
# MyKey
#
# Terraform creates an RSA private key and saves:
#
# MyKey.pem
# ==========================================================

resource "tls_private_key" "my_key" {

  algorithm = "RSA"

  rsa_bits = 4096
}


resource "aws_key_pair" "my_key" {

  key_name = "MyKey"

  public_key = tls_private_key.my_key.public_key_openssh

  tags = {
    Name = "MyKey"
  }
}


# ==========================================================
# SAVE PRIVATE KEY LOCALLY
# ==========================================================

resource "local_sensitive_file" "private_key" {

  content = tls_private_key.my_key.private_key_pem

  filename = "${path.module}/MyKey.pem"

  file_permission = "0600"
}


# ==========================================================
# STEP 5 - PUBLIC EC2 SECURITY GROUP
# ==========================================================

resource "aws_security_group" "public_server_sg" {

  name        = "MyEC2Server_SG"
  description = "Security Group to allow SSH traffic to Public EC2"
  vpc_id      = aws_vpc.my_vpc.id


  # --------------------------------------------------------
  # SSH - Port 22
  #
  # Your lab specifically requests Anywhere.
  #
  # NOTE:
  # 0.0.0.0/0 should NOT normally be used for SSH
  # in production.
  # --------------------------------------------------------

  ingress {
    description = "Allow SSH"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }


  # --------------------------------------------------------
  # Allow outbound traffic
  # --------------------------------------------------------

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "MyEC2Server_SG"
  }
}


# ==========================================================
# STEP 5 - CREATE PUBLIC EC2 INSTANCE
# ==========================================================

resource "aws_instance" "public_server" {

  ami = data.aws_ssm_parameter.amazon_linux_2023.value

  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet.id

  key_name = aws_key_pair.my_key.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.public_server_sg.id
  ]


  tags = {
    Name = "MyPublicServer"
  }
}


# ==========================================================
# STEP 6 - PRIVATE EC2 SECURITY GROUP
# ==========================================================
#
# We use a different AWS Security Group name because AWS
# cannot have two Security Groups with exactly the same
# name inside the same VPC.
#
# SSH is allowed ONLY from the Public EC2 Security Group.
# ==========================================================

resource "aws_security_group" "private_server_sg" {

  name        = "MyPrivateEC2Server_SG"
  description = "Security Group for Private EC2 Server"
  vpc_id      = aws_vpc.my_vpc.id


  # --------------------------------------------------------
  # Allow SSH from Public EC2
  # --------------------------------------------------------

  ingress {

    description = "Allow SSH from Public Server"

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    security_groups = [
      aws_security_group.public_server_sg.id
    ]
  }


  # --------------------------------------------------------
  # Allow outbound Internet traffic through NAT Gateway
  # --------------------------------------------------------

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "MyPrivateEC2Server_SG"
  }
}


# ==========================================================
# STEP 6 - CREATE PRIVATE EC2 INSTANCE
# ==========================================================

resource "aws_instance" "private_server" {

  ami = data.aws_ssm_parameter.amazon_linux_2023.value

  instance_type = "t2.micro"

  subnet_id = aws_subnet.private_subnet.id

  key_name = aws_key_pair.my_key.key_name

  # Private server must NOT have public IP
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.private_server_sg.id
  ]


  tags = {
    Name = "MyPrivateServer"
  }
}


# ==========================================================
# STEP 8 - CREATE ELASTIC IP FOR NAT GATEWAY
# ==========================================================

resource "aws_eip" "nat_eip" {

  domain = "vpc"

  tags = {
    Name = "MyNATGateway-EIP"
  }
}


# ==========================================================
# STEP 8 - CREATE NAT GATEWAY
#
# IMPORTANT:
# NAT Gateway MUST be created inside the PUBLIC subnet.
# ==========================================================

resource "aws_nat_gateway" "my_nat_gateway" {

  allocation_id = aws_eip.nat_eip.id

  subnet_id = aws_subnet.public_subnet.id

  connectivity_type = "public"


  tags = {
    Name = "MyNATGateway"
  }


  # Make sure Internet Gateway exists before NAT Gateway
  depends_on = [
    aws_internet_gateway.my_igw
  ]
}


# ==========================================================
# STEP 9 - CONFIGURE MAIN/PRIVATE ROUTE TABLE
#
# Terraform manages the VPC's default/main route table here.
#
# Private subnet traffic:
#
# 0.0.0.0/0 -> NAT Gateway
# ==========================================================

resource "aws_default_route_table" "private_route_table" {

  default_route_table_id = aws_vpc.my_vpc.default_route_table_id


  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }


  tags = {
    Name = "PrivateRouteTable"
  }
}


# ==========================================================
# ASSOCIATE PRIVATE SUBNET WITH PRIVATE/MAIN ROUTE TABLE
# ==========================================================

resource "aws_route_table_association" "private_subnet_association" {

  subnet_id = aws_subnet.private_subnet.id

  route_table_id = aws_default_route_table.private_route_table.id
}