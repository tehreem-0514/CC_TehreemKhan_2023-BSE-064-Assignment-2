# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr_block))
    error_message = "The VPC CIDR block must be a valid CIDR notation (e.g., 10.0.0.0/16)."
  }
}

# Subnet CIDR Block
variable "subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr_block))
    error_message = "The subnet CIDR block must be a valid CIDR notation (e.g., 10.0.10.0/24)."
  }
}

# Availability Zone
variable "availability_zone" {
  description = "Availability zone where resources will be deployed"
  type        = string
}

# Environment Prefix
variable "env_prefix" {
  description = "Environment prefix for resource naming (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# EC2 Instance Type
variable "instance_type" {
  description = "EC2 instance type for web servers"
  type        = string
  default     = "t3.micro"
}

# Public SSH Key Path
variable "public_key" {
  description = "Path to the public SSH key"
  type        = string
}

# Private SSH Key Path
variable "private_key" {
  description = "Path to the private SSH key"
  type        = string
}

# Backend Servers Configuration
variable "backend_servers" {
  description = "List of backend servers with name and setup script path"
  type = list(object({
    name        = string
    script_path = string
  }))
  default = []
}
