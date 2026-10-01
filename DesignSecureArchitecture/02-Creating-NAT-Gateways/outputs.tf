# ==========================================================
# OUTPUTS
# ==========================================================


output "vpc_id" {
  description = "MyVPC ID"
  value       = aws_vpc.my_vpc.id
}


output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = aws_subnet.public_subnet.id
}


output "private_subnet_id" {
  description = "Private Subnet ID"
  value       = aws_subnet.private_subnet.id
}


output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.my_igw.id
}


output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = aws_nat_gateway.my_nat_gateway.id
}


output "nat_gateway_public_ip" {
  description = "NAT Gateway Elastic IP"
  value       = aws_eip.nat_eip.public_ip
}


output "public_server_public_ip" {
  description = "Public IP of MyPublicServer"
  value       = aws_instance.public_server.public_ip
}


output "public_server_private_ip" {
  description = "Private IP of MyPublicServer"
  value       = aws_instance.public_server.private_ip
}


output "private_server_private_ip" {
  description = "Private IP of MyPrivateServer"
  value       = aws_instance.private_server.private_ip
}


output "ssh_key_file" {
  description = "SSH Private Key"
  value       = local_sensitive_file.private_key.filename
}