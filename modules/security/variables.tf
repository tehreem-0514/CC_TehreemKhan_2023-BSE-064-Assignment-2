variable "vpc_id" {
  description = "VPC ID where security groups will be created"
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix for naming security groups"
  type        = string
}

variable "my_ip" {
  description = "My public IP for SSH access"
  type        = string
}

