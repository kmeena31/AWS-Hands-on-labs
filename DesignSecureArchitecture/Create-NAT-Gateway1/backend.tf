terraform {
  backend "s3" {
    bucket       = "terraform-lab-architect"
    key          = "Create-NAT-Gateway1/terraform.tfstate"
    region       = "us-east-1" # e.g., us-east-1
    encrypt      = true
    use_lockfile = true
  }
}