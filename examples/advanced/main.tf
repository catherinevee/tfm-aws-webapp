# =============================================================================
# Advanced Example - Dynamic Web Application
# =============================================================================
# This example demonstrates a production-ready deployment of the web application
# module with enhanced security, monitoring, and high availability features.

terraform {
  required_version = "~> 1.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
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
  project_name = "advanced-webapp"
  environment  = "prod"
  aws_region   = "us-east-1"

  # VPC Configuration
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]

  # HTTPS Configuration
  enable_https     = true
  certificate_arn  = var.certificate_arn

  # RDS Configuration
  rds_engine         = "mysql"
  rds_engine_version = "8.0.35"
  rds_instance_class = "db.t3.small"
  rds_password       = var.rds_password
  rds_multi_az       = true
  rds_allocated_storage = 50
  rds_max_allocated_storage = 200
  rds_backup_retention_period = 30
  rds_performance_insights_enabled = true
  rds_deletion_protection = true

  # Auto Scaling Configuration
  instance_type    = "t3.small"
  desired_capacity = 3
  min_size         = 2
  max_size         = 5

  # Security Configuration
  allowed_ssh_cidrs = var.allowed_ssh_cidrs
  enable_deletion_protection = true

  # Monitoring Configuration
  log_retention_days = 90

  # RDS Parameters
  rds_parameters = [
    {
      name  = "max_connections"
      value = "200"
    },
    {
      name  = "innodb_buffer_pool_size"
      value = "268435456"
    },
    {
      name  = "slow_query_log"
      value = "1"
    },
    {
      name  = "long_query_time"
      value = "2"
    }
  ]

  # Common tags
  common_tags = {
    Environment = "production"
    Project     = "advanced-webapp"
    Owner       = "devops-team"
    CostCenter  = "engineering"
    Backup      = "true"
    Monitoring  = "true"
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

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
  default     = ["10.0.0.0/16"]
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

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.webapp.vpc_id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.webapp.autoscaling_group_name
}

output "infrastructure_summary" {
  description = "Summary of the deployed infrastructure"
  value       = module.webapp.infrastructure_summary
} 