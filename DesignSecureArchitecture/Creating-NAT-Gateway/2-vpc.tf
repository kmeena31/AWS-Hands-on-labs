#step 1: Create VPC
resource "aws_vpc" "my_vpc"{

    cidr_block = "locals.vpc_cidr"
    instance_tenancy = "default"
    tags = {
        Name = "${locals.env}-main"
    }
}