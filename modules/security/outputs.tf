output "nginx_sg_id" {
  description = "ID of the Nginx security group"
  value       = aws_security_group.nginx_sg.id
}

output "backend_sg_id" {
  description = "ID of the backend security group"
  value       = aws_security_group.backend_sg.id
}
