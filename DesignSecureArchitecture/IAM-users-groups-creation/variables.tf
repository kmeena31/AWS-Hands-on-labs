variable "lab_password" {
  description = "Temporary password for IAM lab users"
  type        = string
  sensitive   = true
  default     = "Today@123"
}