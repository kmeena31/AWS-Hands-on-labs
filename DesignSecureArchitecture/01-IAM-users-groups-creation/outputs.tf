output "aws_region" {
  description = "AWS region configured for this lab"
  value       = "us-east-1"
}


output "dev_team_users" {
  description = "Users belonging to Dev-Team"

  value = [
    aws_iam_user.john.name,
    aws_iam_user.sarah.name
  ]
}


output "hr_team_users" {
  description = "Users belonging to HR-Team"

  value = [
    aws_iam_user.ted.name,
    aws_iam_user.rita.name
  ]
}


output "dev_team_policies" {
  description = "Policies attached to Dev-Team"

  value = [
    aws_iam_group_policy_attachment.dev_ec2_readonly.policy_arn,
    aws_iam_group_policy_attachment.dev_s3_readonly.policy_arn
  ]
}


output "hr_team_policy" {
  description = "Policy attached to HR-Team"

  value = aws_iam_group_policy_attachment.hr_billing.policy_arn
}

output "john_password" {
  value     = aws_iam_user_login_profile.john.password
  sensitive = true
}

output "sarah_password" {
  value     = aws_iam_user_login_profile.sarah.password
  sensitive = true
}

output "ted_password" {
  value     = aws_iam_user_login_profile.ted.password
  sensitive = true
}

output "rita_password" {
  value     = aws_iam_user_login_profile.rita.password
  sensitive = true
}