
# AWS provider for setting Region

provider "aws" {
  region = "us-east-1"
}

#step 1: Create VPC
resource "aws_vpc" "my_vpc"{

    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags = {
        Name = "MyVPC"
    }
}