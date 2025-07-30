# =============================================================================
# Basic Example - Dynamic Web Application
# =============================================================================
# This example demonstrates a basic deployment of the web application module
# with minimal configuration for development environments.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# =============================================================================
# Web Application Module
# =============================================================================

module "webapp" {
  source = "../../"

  # Basic Configuration
  project_name = "basic-webapp"
  environment  = "dev"
  aws_region   = "us-east-1"

  # RDS Configuration (required)
  rds_password = var.rds_password

  # Auto Scaling Configuration
  instance_type    = "t3.micro"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3

  # Common tags
  common_tags = {
    Environment = "dev"
    Project     = "basic-webapp"
    Owner       = "devops-team"
    CostCenter  = "engineering"
  }
}

# =============================================================================
# Variables
# =============================================================================

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

# =============================================================================
# Outputs
# =============================================================================

output "webapp_url" {
  description = "URL of the web application"
  value       = module.webapp.webapp_url
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.webapp.alb_dns_name
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.webapp.rds_endpoint
}

output "infrastructure_summary" {
  description = "Summary of the deployed infrastructure"
  value       = module.webapp.infrastructure_summary
} 