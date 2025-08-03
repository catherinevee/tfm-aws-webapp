# =============================================================================
# Basic Terraform Tests for AWS Web Application Module
# =============================================================================

# Test basic module deployment with minimal configuration
run "basic_deployment" {
  command = plan

  variables {
    project_name = "test-webapp"
    environment  = "test"
    rds_password = "TestPassword123!"
  }

  # Verify VPC is created with correct CIDR
  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block should be 10.0.0.0/16"
  }

  # Verify correct number of subnets are created
  assert {
    condition     = length(aws_subnet.public) == 2
    error_message = "Should create 2 public subnets"
  }

  assert {
    condition     = length(aws_subnet.private) == 2
    error_message = "Should create 2 private subnets"
  }

  assert {
    condition     = length(aws_subnet.database) == 2
    error_message = "Should create 2 database subnets"
  }

  # Verify security groups are created
  assert {
    condition     = aws_security_group.alb.name == "test-webapp-alb-sg"
    error_message = "ALB security group should have correct name"
  }

  assert {
    condition     = aws_security_group.ec2.name == "test-webapp-ec2-sg"
    error_message = "EC2 security group should have correct name"
  }

  assert {
    condition     = aws_security_group.rds.name == "test-webapp-rds-sg"
    error_message = "RDS security group should have correct name"
  }

  # Verify ALB is created
  assert {
    condition     = aws_lb.main.name == "test-webapp-alb"
    error_message = "ALB should have correct name"
  }

  # Verify Auto Scaling Group is created
  assert {
    condition     = aws_autoscaling_group.main.name == "test-webapp-asg"
    error_message = "Auto Scaling Group should have correct name"
  }

  # Verify RDS instance is created
  assert {
    condition     = aws_db_instance.main.identifier == "test-webapp-rds"
    error_message = "RDS instance should have correct identifier"
  }
}

# Test variable validation
run "variable_validation" {
  command = plan

  variables {
    project_name = "invalid-project-name-with-uppercase"
    environment  = "test"
    rds_password = "TestPassword123!"
  }

  # This should fail due to invalid project name
  expect_failures = [
    var.project_name,
  ]
}

# Test HTTPS configuration
run "https_configuration" {
  command = plan

  variables {
    project_name    = "test-webapp-https"
    environment     = "test"
    rds_password    = "TestPassword123!"
    enable_https    = true
    certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/test-cert"
  }

  # Verify HTTPS listener is created when HTTPS is enabled
  assert {
    condition     = length(aws_lb_listener.https) > 0
    error_message = "HTTPS listener should be created when HTTPS is enabled"
  }
}

# Test RDS configuration
run "rds_configuration" {
  command = plan

  variables {
    project_name = "test-webapp-rds"
    environment  = "test"
    rds_password = "TestPassword123!"
    
    # Test RDS parameters
    rds_parameters = [
      {
        name  = "max_connections"
        value = "200"
      },
      {
        name  = "innodb_buffer_pool_size"
        value = "134217728"
      }
    ]
  }

  # Verify RDS parameter group is created with parameters
  assert {
    condition     = length(aws_db_parameter_group.main.parameter) == 2
    error_message = "RDS parameter group should have 2 parameters"
  }
}

# Test Auto Scaling configuration
run "autoscaling_configuration" {
  command = plan

  variables {
    project_name     = "test-webapp-asg"
    environment      = "test"
    rds_password     = "TestPassword123!"
    instance_type    = "t3.small"
    desired_capacity = 3
    min_size         = 2
    max_size         = 5
  }

  # Verify Auto Scaling Group has correct configuration
  assert {
    condition     = aws_autoscaling_group.main.desired_capacity == 3
    error_message = "Auto Scaling Group should have correct desired capacity"
  }

  assert {
    condition     = aws_autoscaling_group.main.min_size == 2
    error_message = "Auto Scaling Group should have correct min size"
  }

  assert {
    condition     = aws_autoscaling_group.main.max_size == 5
    error_message = "Auto Scaling Group should have correct max size"
  }
}

# Test monitoring configuration
run "monitoring_configuration" {
  command = plan

  variables {
    project_name = "test-webapp-monitoring"
    environment  = "test"
    rds_password = "TestPassword123!"
    
    # Test monitoring configuration
    log_retention_days = 90
  }

  # Verify CloudWatch log groups are created
  assert {
    condition     = aws_cloudwatch_log_group.application.name == "/aws/webapp/test-webapp-monitoring/application"
    error_message = "Application log group should have correct name"
  }

  assert {
    condition     = aws_cloudwatch_log_group.rds.name == "/aws/webapp/test-webapp-monitoring/rds"
    error_message = "RDS log group should have correct name"
  }

  # Verify CloudWatch alarms are created
  assert {
    condition     = aws_cloudwatch_metric_alarm.cpu_high.alarm_name == "test-webapp-monitoring-cpu-high"
    error_message = "CPU high alarm should have correct name"
  }

  assert {
    condition     = aws_cloudwatch_metric_alarm.cpu_low.alarm_name == "test-webapp-monitoring-cpu-low"
    error_message = "CPU low alarm should have correct name"
  }
} 