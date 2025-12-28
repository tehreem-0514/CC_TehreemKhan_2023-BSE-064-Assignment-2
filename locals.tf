# Get public IP dynamically
data "http" "my_ip" {
  url = "https://icanhazip.com"
}

locals {
  # My public IP with /32
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"

  # Common tags for all resources
  common_tags = {
    Environment = var.env_prefix
    Project     = "Assignment-2"
    ManagedBy   = "Terraform"
  }

  # Backend server configuration
  backend_servers = [
    {
      name        = "web"
      suffix      = "1"
      script_path = "./scripts/apache-setup.sh"
    },
    {
      name        = "web"
      suffix      = "2"
      script_path = "./scripts/apache-setup.sh"
    },
    {
      name        = "web"
      suffix      = "3"
      script_path = "./scripts/apache-setup.sh"
    }
  ]
}
