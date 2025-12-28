variable "env_prefix" {
  description = "Environment prefix for naming"
  type        = string
}

variable "instance_name" {
  description = "Base name of the EC2 instance"
  type        = string
}

variable "instance_suffix" {
  description = "Unique suffix for instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "public_key" {
  description = "Public SSH key path"
  type        = string
}

variable "script_path" {
  description = "User data script path"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
