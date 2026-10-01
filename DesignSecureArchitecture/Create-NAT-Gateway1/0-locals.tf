locals {
    region = "us-east-1"
    vpc_cidr = "10.0.0.0/16"
    env = "dev"
    
     azs  = [ "us-east-2a", "us-east-2b"]
     public_subnets = ["10.0.0.0/24", "10.0.2.0/24" ]
}