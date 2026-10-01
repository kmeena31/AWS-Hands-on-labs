locals {
    region = "us-east-1"
    vpc_cidr = "10.0.0.0/16"
    env = "dev"
    
     azs  = [ "us-east-2a"]
     public_subnets = ["10.0.0.0/24"]
}