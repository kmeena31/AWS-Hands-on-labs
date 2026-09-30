 Creating IAM Users & Groups in  AWS

  Creating Users & groups and attaching policy for each group using terraform 
 ==========================================================
# AWS IAM LAB
# Region: us-east-1
#
# Users:
# John  -> Dev-Team 
# Sarah -> Dev-Team
# Ted   -> HR-Team
# Rita  -> HR-Team
#
# Groups:
# Dev-Team
# HR-Team

# Policy Attached for each team 
# Dev-Team: AmazonEC2ReadOnlyAccess, AmazonS3ReadOnlyAccess
# HR-Team: Billing
# ==========================================================

Example:

1. Declaring the provider information in providers.tf
<!-- terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
} -->

2. Creating user and adding user to respective  group and attach policy for each group in  main.tf file
 Please see main.tf file 

3. outputs file will show "users, groups, policy attached to each group"