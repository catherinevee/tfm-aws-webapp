# AWS Dynamic Web Application Terraform Module

A comprehensive Terraform module for deploying dynamic web applications on AWS with EC2, Application Load Balancer (ALB), and RDS database.

## 🚀 Features

- **Complete Infrastructure**: VPC, subnets, security groups, and networking
- **Auto Scaling**: EC2 instances in Auto Scaling Group with CloudWatch alarms
- **Load Balancing**: Application Load Balancer with health checks
- **Database**: RDS instance with configurable engine and settings
- **Monitoring**: CloudWatch logs, metrics, and alarms
- **Security**: IAM roles, security groups, and encryption
- **High Availability**: Multi-AZ deployment options
- **SSL/TLS**: Optional HTTPS support with ACM certificates

## 📋 Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- AWS account with access to required services

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Internet                             │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                Application Load Balancer                    │
│                     (Public Subnets)                       │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│              Auto Scaling Group (EC2 Instances)            │
│                    (Private Subnets)                       │
└─────────────────────┬───────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────┐
│                    RDS Database                            │
│                  (Database Subnets)                        │
└─────────────────────────────────────────────────────────────┘
```

## 📦 Module Structure

```
tfm-aws-webapp/
├── main.tf                 # Main Terraform configuration
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── versions.tf             # Terraform and provider versions
├── templates/
│   └── user_data.sh        # EC2 instance bootstrap script
├── tests/
│   └── basic.tftest.hcl    # Terraform test suite
├── RESOURCE_MAP.md         # Comprehensive resource documentation
├── CHANGELOG.md            # Version history and changes
├── CONTRIBUTING.md         # Contribution guidelines
├── CODE_OF_CONDUCT.md      # Community code of conduct
└── README.md               # This file
```

## 📊 Resource Map

For a detailed overview of all AWS resources created by this module, including dependencies, naming conventions, and security considerations, see the [Resource Map](RESOURCE_MAP.md) documentation.

**Resource Summary:**
- **34 total resources** across 7 categories
- **Networking**: VPC, subnets, gateways, route tables
- **Security**: Security groups for ALB, EC2, and RDS
- **Load Balancing**: ALB, target groups, listeners
- **Compute**: Launch template and Auto Scaling Group
- **Database**: RDS instance and supporting resources
- **IAM**: Roles and policies for EC2 and RDS
- **Monitoring**: CloudWatch logs, alarms, and metrics

## 🔧 Usage

### Basic Example

```hcl
module "webapp" {
  source = "./tfm-aws-webapp"

  project_name = "my-webapp"
  environment  = "dev"
  
  # RDS Configuration
  rds_password = "your-secure-password"
  
  # Auto Scaling Configuration
  instance_type    = "t3.micro"
  desired_capacity = 2
  min_size         = 1
  max_size         = 3
  
  # Common tags
  common_tags = {
    Environment = "dev"
    Project     = "my-webapp"
    Owner       = "devops-team"
  }
}

# Output the web application URL
output "webapp_url" {
  value = module.webapp.webapp_url
}
```

### Advanced Example with HTTPS

```hcl
module "webapp" {
  source = "./tfm-aws-webapp"

  project_name = "production-webapp"
  environment  = "prod"
  
  # VPC Configuration
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]
  
  # HTTPS Configuration
  enable_https     = true
  certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/your-cert-id"
  
  # RDS Configuration
  rds_engine         = "mysql"
  rds_engine_version = "8.0.35"
  rds_instance_class = "db.t3.small"
  rds_password       = "your-secure-password"
  rds_multi_az       = true
  
  # Auto Scaling Configuration
  instance_type    = "t3.small"
  desired_capacity = 3
  min_size         = 2
  max_size         = 5
  
  # Monitoring Configuration
  log_retention_days = 90
  rds_performance_insights_enabled = true
  
  # Security Configuration
  allowed_ssh_cidrs = ["10.0.0.0/16", "192.168.1.0/24"]
  
  common_tags = {
    Environment = "production"
    Project     = "production-webapp"
    Owner       = "devops-team"
    CostCenter  = "engineering"
  }
}
```

## 📝 Input Variables

### General Configuration

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_name | Name of the project/application | `string` | n/a | yes |
| environment | Environment name (dev, staging, prod) | `string` | `"dev"` | no |
| aws_region | AWS region to deploy resources | `string` | `"us-east-1"` | no |
| common_tags | Common tags to apply to all resources | `map(string)` | `{}` | no |

### VPC and Networking

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| public_subnet_cidrs | CIDR blocks for public subnets | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]` | no |
| private_subnet_cidrs | CIDR blocks for private subnets | `list(string)` | `["10.0.10.0/24", "10.0.11.0/24"]` | no |
| database_subnet_cidrs | CIDR blocks for database subnets | `list(string)` | `["10.0.20.0/24", "10.0.21.0/24"]` | no |
| enable_nat_gateway | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| allowed_ssh_cidrs | CIDR blocks allowed to SSH to EC2 instances | `list(string)` | `["10.0.0.0/16"]` | no |

### Application Load Balancer

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable_https | Enable HTTPS listener | `bool` | `false` | no |
| certificate_arn | ARN of the SSL certificate for HTTPS | `string` | `""` | no |
| health_check_path | Path for ALB health checks | `string` | `"/health"` | no |
| enable_deletion_protection | Enable deletion protection for the ALB | `bool` | `false` | no |

### EC2 and Auto Scaling

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| min_size | Minimum number of instances in the Auto Scaling Group | `number` | `1` | no |
| max_size | Maximum number of instances in the Auto Scaling Group | `number` | `3` | no |
| desired_capacity | Desired number of instances in the Auto Scaling Group | `number` | `2` | no |

### RDS Database

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| rds_engine | RDS database engine | `string` | `"mysql"` | no |
| rds_engine_version | RDS database engine version | `string` | `"8.0.35"` | no |
| rds_instance_class | RDS instance class | `string` | `"db.t3.micro"` | no |
| rds_allocated_storage | RDS allocated storage in GB | `number` | `20` | no |
| rds_max_allocated_storage | RDS maximum allocated storage in GB | `number` | `100` | no |
| rds_storage_type | RDS storage type | `string` | `"gp2"` | no |
| rds_database_name | RDS database name | `string` | `"webapp"` | no |
| rds_username | RDS master username | `string` | `"admin"` | no |
| rds_password | RDS master password | `string` | n/a | yes |
| rds_port | RDS database port | `number` | `3306` | no |
| rds_backup_retention_period | RDS backup retention period in days | `number` | `7` | no |
| rds_backup_window | RDS backup window | `string` | `"03:00-04:00"` | no |
| rds_maintenance_window | RDS maintenance window | `string` | `"sun:04:00-sun:05:00"` | no |
| rds_multi_az | Enable RDS Multi-AZ deployment | `bool` | `false` | no |
| rds_skip_final_snapshot | Skip final snapshot when destroying RDS instance | `bool` | `false` | no |
| rds_deletion_protection | Enable RDS deletion protection | `bool` | `false` | no |
| rds_performance_insights_enabled | Enable RDS Performance Insights | `bool` | `false` | no |
| rds_monitoring_interval | RDS monitoring interval in seconds | `number` | `60` | no |
| rds_parameters | RDS parameter group parameters | `list(object)` | `[]` | no |

### Monitoring and Logging

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| log_retention_days | CloudWatch log retention period in days | `number` | `30` | no |

## 📤 Outputs

### VPC and Networking

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr_block | CIDR block of the VPC |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| database_subnet_ids | IDs of the database subnets |

### Application Load Balancer

| Name | Description |
|------|-------------|
| alb_id | ID of the Application Load Balancer |
| alb_arn | ARN of the Application Load Balancer |
| alb_dns_name | DNS name of the Application Load Balancer |
| alb_zone_id | Zone ID of the Application Load Balancer |
| alb_target_group_arn | ARN of the ALB target group |

### Auto Scaling Group

| Name | Description |
|------|-------------|
| autoscaling_group_id | ID of the Auto Scaling Group |
| autoscaling_group_name | Name of the Auto Scaling Group |
| autoscaling_group_arn | ARN of the Auto Scaling Group |
| launch_template_id | ID of the launch template |

### RDS Database

| Name | Description |
|------|-------------|
| rds_instance_id | ID of the RDS instance |
| rds_endpoint | Endpoint of the RDS instance |
| rds_address | Address of the RDS instance |
| rds_port | Port of the RDS instance |
| rds_database_name | Name of the RDS database |

### Composite Outputs

| Name | Description |
|------|-------------|
| webapp_url | URL of the web application |
| database_connection_string | Database connection string (without password) |
| infrastructure_summary | Summary of the deployed infrastructure |

## 🔒 Security Features

- **Security Groups**: Restrictive security groups for ALB, EC2, and RDS
- **IAM Roles**: Least privilege IAM roles for EC2 and RDS monitoring
- **Encryption**: RDS storage encryption enabled by default
- **Private Subnets**: EC2 instances deployed in private subnets
- **SSL/TLS**: Optional HTTPS support with ACM certificates
- **SSM Access**: EC2 instances can be accessed via AWS Systems Manager

## 📊 Monitoring and Logging

- **CloudWatch Logs**: Application, Apache, and PHP error logs
- **CloudWatch Metrics**: CPU, memory, disk, and network metrics
- **Auto Scaling Alarms**: CPU-based scaling policies
- **RDS Monitoring**: Enhanced monitoring and Performance Insights
- **Health Checks**: ALB health checks and application health endpoints

## 🚀 Deployment

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Plan the Deployment

```bash
terraform plan -var="rds_password=your-secure-password"
```

### 3. Apply the Configuration

```bash
terraform apply -var="rds_password=your-secure-password"
```

### 4. Access the Application

After deployment, you can access your web application using the `webapp_url` output.

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy -var="rds_password=your-secure-password"
```

**⚠️ Warning**: This will permanently delete all resources including the RDS database and its data.

## 🔧 Customization

### Custom User Data

The module includes a comprehensive user data script that:
- Installs Apache, PHP, and MySQL client
- Configures the web application
- Sets up CloudWatch monitoring
- Applies security hardening

### Custom RDS Parameters

You can specify custom RDS parameter group parameters:

```hcl
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
```

### Custom Health Check Path

Modify the health check path for your application:

```hcl
health_check_path = "/api/health"
```

## 🐛 Troubleshooting

### Common Issues

1. **RDS Connection Issues**: Ensure security groups allow traffic between EC2 and RDS
2. **ALB Health Check Failures**: Verify the health check path exists in your application
3. **Auto Scaling Issues**: Check CloudWatch alarms and scaling policies
4. **SSL Certificate Issues**: Ensure the certificate ARN is valid and in the correct region

### Debugging

1. **Check EC2 Instance Logs**: Use AWS Systems Manager to access instances
2. **Review CloudWatch Logs**: Check application and system logs
3. **Verify Security Groups**: Ensure proper network access
4. **Test Database Connectivity**: Use the health check endpoint

## 📚 Additional Resources

- [AWS Terraform Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Application Load Balancer Documentation](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/)
- [AWS RDS Documentation](https://docs.aws.amazon.com/rds/)
- [AWS Auto Scaling Documentation](https://docs.aws.amazon.com/autoscaling/)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for detailed information on how to contribute to this project.

### Quick Start

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass (`terraform test`)
6. Update documentation as needed
7. Submit a pull request

### Code of Conduct

This project adheres to our [Code of Conduct](CODE_OF_CONDUCT.md). Please read it before contributing.

### Testing

Run the test suite to ensure your changes work correctly:

```bash
# Run all tests
terraform test

# Run specific test file
terraform test tests/basic.tftest.hcl
```

## 📄 License

This module is licensed under the MIT License. See the LICENSE file for details.

## ⚠️ Disclaimer

This module is provided as-is without any warranties. Please review the configuration and test thoroughly in a non-production environment before deploying to production.