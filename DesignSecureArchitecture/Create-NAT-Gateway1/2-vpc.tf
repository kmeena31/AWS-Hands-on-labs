#step 1: Create VPC
resource "aws_vpc" "my_vpc"{

    cidr_block = local.vpc_cidr
    instance_tenancy = "default"
    tags = {
        Name = "${local.env}-main"
    }
}