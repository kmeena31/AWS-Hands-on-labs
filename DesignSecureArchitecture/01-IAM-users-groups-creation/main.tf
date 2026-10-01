# ==========================================================
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
# ==========================================================


# ==========================================================
# STEP 1 - CREATE IAM USERS
# ==========================================================

# --------------------------
# User 1 - John
# --------------------------

resource "aws_iam_user" "john" {
  name = "John"

  tags = {
    "Dev-Team" = "Developers"
  }
}

resource "aws_iam_user_login_profile" "john" {
  user                    = aws_iam_user.john.name
  password_length         = 16
  password_reset_required = false
}


# --------------------------
# User 2 - Sarah
# --------------------------

resource "aws_iam_user" "sarah" {
  name = "Sarah"

  tags = {
    "Dev-Team" = "Developers"
  }
}

resource "aws_iam_user_login_profile" "sarah" {
  user                    = aws_iam_user.sarah.name
  password_length         = 16
  password_reset_required = false
}


# --------------------------
# User 3 - Ted
# --------------------------

resource "aws_iam_user" "ted" {
  name = "Ted"

  tags = {
    "HR-Team" = "HR"
  }
}

resource "aws_iam_user_login_profile" "ted" {
  user                    = aws_iam_user.ted.name
  password_length         = 16
  password_reset_required = false
}


# --------------------------
# User 4 - Rita
# --------------------------

resource "aws_iam_user" "rita" {
  name = "Rita"

  tags = {
    "HR-Team" = "HR"
  }
}

resource "aws_iam_user_login_profile" "rita" {
  user                    = aws_iam_user.rita.name
  password_length         = 16
  password_reset_required = false
}


# ==========================================================
# STEP 2 - CREATE IAM GROUPS
# ==========================================================

resource "aws_iam_group" "dev_team" {
  name = "Dev-Team"
}

resource "aws_iam_group" "hr_team" {
  name = "HR-Team"
}


# ==========================================================
# STEP 3 - ADD USERS TO GROUPS
# ==========================================================

# John and Sarah -> Dev-Team

resource "aws_iam_group_membership" "dev_team_members" {
  name = "dev-team-members"

  users = [
    aws_iam_user.john.name,
    aws_iam_user.sarah.name
  ]

  group = aws_iam_group.dev_team.name
}


# Ted and Rita -> HR-Team

resource "aws_iam_group_membership" "hr_team_members" {
  name = "hr-team-members"

  users = [
    aws_iam_user.ted.name,
    aws_iam_user.rita.name
  ]

  group = aws_iam_group.hr_team.name
}


# ==========================================================
# STEP 4 - DEV-TEAM PERMISSIONS
# ==========================================================

# EC2 Read Only

resource "aws_iam_group_policy_attachment" "dev_ec2_readonly" {
  group = aws_iam_group.dev_team.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


# S3 Read Only

resource "aws_iam_group_policy_attachment" "dev_s3_readonly" {
  group = aws_iam_group.dev_team.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}


# ==========================================================
# STEP 5 - HR-TEAM BILLING PERMISSIONS
# ==========================================================

resource "aws_iam_group_policy_attachment" "hr_billing" {
  group = aws_iam_group.hr_team.name

  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}