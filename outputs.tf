# =============================================================================
# Outputs for Dynamic Web Application Module
# =============================================================================

# =============================================================================
# VPC and Networking Outputs
# =============================================================================

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  description = "IDs of the database subnets"
  value       = aws_subnet.database[*].id
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = aws_subnet.private[*].cidr_block
}

output "database_subnet_cidrs" {
  description = "CIDR blocks of the database subnets"
  value       = aws_subnet.database[*].cidr_block
}

# =============================================================================
# Security Group Outputs
# =============================================================================

output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "ID of the EC2 security group"
  value       = aws_security_group.ec2.id
}

output "rds_security_group_id" {
  description = "ID of the RDS security group"
  value       = aws_security_group.rds.id
}

# =============================================================================
# Application Load Balancer Outputs
# =============================================================================

output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "alb_target_group_arn" {
  description = "ARN of the ALB target group"
  value       = aws_lb_target_group.main.arn
}

output "alb_target_group_name" {
  description = "Name of the ALB target group"
  value       = aws_lb_target_group.main.name
}

# =============================================================================
# Auto Scaling Group Outputs
# =============================================================================

output "autoscaling_group_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.main.arn
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.main.id
}

output "launch_template_name" {
  description = "Name of the launch template"
  value       = aws_launch_template.main.name
}

output "launch_template_latest_version" {
  description = "Latest version of the launch template"
  value       = aws_launch_template.main.latest_version
}

# =============================================================================
# RDS Database Outputs
# =============================================================================

output "rds_instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.main.id
}

output "rds_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.main.endpoint
}

output "rds_address" {
  description = "Address of the RDS instance"
  value       = aws_db_instance.main.address
}

output "rds_port" {
  description = "Port of the RDS instance"
  value       = aws_db_instance.main.port
}

output "rds_database_name" {
  description = "Name of the RDS database"
  value       = aws_db_instance.main.db_name
}

output "rds_username" {
  description = "Master username of the RDS instance"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "rds_subnet_group_id" {
  description = "ID of the RDS subnet group"
  value       = aws_db_subnet_group.main.id
}

output "rds_subnet_group_arn" {
  description = "ARN of the RDS subnet group"
  value       = aws_db_subnet_group.main.arn
}

output "rds_parameter_group_id" {
  description = "ID of the RDS parameter group"
  value       = aws_db_parameter_group.main.id
}

output "rds_parameter_group_arn" {
  description = "ARN of the RDS parameter group"
  value       = aws_db_parameter_group.main.arn
}

# =============================================================================
# IAM Role Outputs
# =============================================================================

output "ec2_iam_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2.arn
}

output "ec2_iam_role_name" {
  description = "Name of the EC2 IAM role"
  value       = aws_iam_role.ec2.name
}

output "ec2_instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.arn
}

output "ec2_instance_profile_name" {
  description = "Name of the EC2 instance profile"
  value       = aws_iam_instance_profile.ec2.name
}

output "rds_monitoring_role_arn" {
  description = "ARN of the RDS monitoring IAM role"
  value       = aws_iam_role.rds_monitoring.arn
}

output "rds_monitoring_role_name" {
  description = "Name of the RDS monitoring IAM role"
  value       = aws_iam_role.rds_monitoring.name
}

# =============================================================================
# CloudWatch Outputs
# =============================================================================

output "application_log_group_name" {
  description = "Name of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.name
}

output "application_log_group_arn" {
  description = "ARN of the application CloudWatch log group"
  value       = aws_cloudwatch_log_group.application.arn
}

output "rds_log_group_name" {
  description = "Name of the RDS CloudWatch log group"
  value       = aws_cloudwatch_log_group.rds.name
}

output "rds_log_group_arn" {
  description = "ARN of the RDS CloudWatch log group"
  value       = aws_cloudwatch_log_group.rds.arn
}

# =============================================================================
# CloudWatch Alarm Outputs
# =============================================================================

output "cpu_high_alarm_arn" {
  description = "ARN of the CPU high utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_high.arn
}

output "cpu_low_alarm_arn" {
  description = "ARN of the CPU low utilization alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_low.arn
}

# =============================================================================
# Auto Scaling Policy Outputs
# =============================================================================

output "scale_up_policy_arn" {
  description = "ARN of the scale up policy"
  value       = aws_autoscaling_policy.scale_up.arn
}

output "scale_down_policy_arn" {
  description = "ARN of the scale down policy"
  value       = aws_autoscaling_policy.scale_down.arn
}

# =============================================================================
# Composite Outputs
# =============================================================================

output "webapp_url" {
  description = "URL of the web application"
  value       = var.enable_https ? "https://${aws_lb.main.dns_name}" : "http://${aws_lb.main.dns_name}"
}

output "database_connection_string" {
  description = "Database connection string (without password)"
  value       = "${var.rds_engine}://${aws_db_instance.main.username}@${aws_db_instance.main.endpoint}/${aws_db_instance.main.db_name}"
  sensitive   = true
}

output "infrastructure_summary" {
  description = "Summary of the deployed infrastructure"
  value = {
    vpc_id                    = aws_vpc.main.id
    vpc_cidr                  = aws_vpc.main.cidr_block
    public_subnets            = length(aws_subnet.public)
    private_subnets           = length(aws_subnet.private)
    database_subnets          = length(aws_subnet.database)
    alb_dns_name              = aws_lb.main.dns_name
    webapp_url                = var.enable_https ? "https://${aws_lb.main.dns_name}" : "http://${aws_lb.main.dns_name}"
    rds_endpoint              = aws_db_instance.main.endpoint
    autoscaling_group_name    = aws_autoscaling_group.main.name
    instance_type             = var.instance_type
    database_engine           = var.rds_engine
    database_instance_class   = var.rds_instance_class
    environment               = var.environment
    project_name              = var.project_name
  }
} 