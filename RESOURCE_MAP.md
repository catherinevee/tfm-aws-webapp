# AWS Web Application Module - Resource Map

This document provides a comprehensive overview of all AWS resources created by the `tfm-aws-webapp` Terraform module, organized by category with descriptions and dependencies.

## 📊 Resource Overview

| Category | Resource Count | Description |
|----------|---------------|-------------|
| **Networking** | 12 | VPC, subnets, gateways, route tables |
| **Security** | 3 | Security groups for ALB, EC2, and RDS |
| **Load Balancing** | 4 | ALB, target group, listeners |
| **Compute** | 2 | Launch template and Auto Scaling Group |
| **Database** | 3 | RDS instance, subnet group, parameter group |
| **IAM** | 4 | Roles and policies for EC2 and RDS |
| **Monitoring** | 6 | CloudWatch logs, alarms, and metrics |
| **Total** | **34** | Complete web application infrastructure |

## 🏗️ Resource Categories

### 1. Networking Resources

#### Core VPC Infrastructure
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_vpc.main` | VPC | Main VPC for the web application | None |
| `aws_subnet.public` | Subnet | Public subnets for ALB | VPC |
| `aws_subnet.private` | Subnet | Private subnets for EC2 instances | VPC |
| `aws_subnet.database` | Subnet | Database subnets for RDS | VPC |

#### Internet Connectivity
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_internet_gateway.main` | Internet Gateway | Internet access for public subnets | VPC |
| `aws_eip.nat` | Elastic IP | Static IP for NAT Gateway | VPC |
| `aws_nat_gateway.main` | NAT Gateway | Internet access for private subnets | EIP, Public Subnets |

#### Routing
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_route_table.public` | Route Table | Routes for public subnets | Internet Gateway |
| `aws_route_table.private` | Route Table | Routes for private subnets | NAT Gateway |
| `aws_route_table_association.public` | Route Association | Associates public subnets with route table | Route Tables, Public Subnets |
| `aws_route_table_association.private` | Route Association | Associates private subnets with route table | Route Tables, Private Subnets |

### 2. Security Resources

#### Security Groups
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_security_group.alb` | Security Group | Controls traffic to ALB | VPC |
| `aws_security_group.ec2` | Security Group | Controls traffic to EC2 instances | VPC |
| `aws_security_group.rds` | Security Group | Controls traffic to RDS database | VPC |

### 3. Load Balancing Resources

#### Application Load Balancer
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_lb.main` | Application Load Balancer | Distributes traffic to EC2 instances | Public Subnets, ALB Security Group |
| `aws_lb_target_group.main` | Target Group | Defines target instances and health checks | VPC |
| `aws_lb_listener.http` | Listener | HTTP traffic listener | ALB, Target Group |
| `aws_lb_listener.https` | Listener | HTTPS traffic listener (optional) | ALB, Target Group, Certificate |

### 4. Compute Resources

#### Auto Scaling Infrastructure
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_launch_template.main` | Launch Template | Defines EC2 instance configuration | Security Groups, IAM Role |
| `aws_autoscaling_group.main` | Auto Scaling Group | Manages EC2 instance scaling | Launch Template, Private Subnets |

#### Auto Scaling Policies
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_autoscaling_policy.scale_up` | Scaling Policy | Scales out based on CPU | Auto Scaling Group |
| `aws_autoscaling_policy.scale_down` | Scaling Policy | Scales in based on CPU | Auto Scaling Group |

### 5. Database Resources

#### RDS Infrastructure
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_db_subnet_group.main` | DB Subnet Group | Subnets for RDS deployment | Database Subnets |
| `aws_db_parameter_group.main` | DB Parameter Group | Database configuration parameters | None |
| `aws_db_instance.main` | RDS Instance | Database server | Subnet Group, Parameter Group, Security Group |

### 6. IAM Resources

#### EC2 IAM Configuration
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_iam_role.ec2` | IAM Role | Permissions for EC2 instances | None |
| `aws_iam_instance_profile.ec2` | Instance Profile | Links IAM role to EC2 instances | EC2 IAM Role |
| `aws_iam_role_policy_attachment.ec2_ssm` | Policy Attachment | SSM access for EC2 | EC2 IAM Role |
| `aws_iam_role_policy_attachment.ec2_cloudwatch` | Policy Attachment | CloudWatch access for EC2 | EC2 IAM Role |

#### RDS IAM Configuration
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_iam_role.rds_monitoring` | IAM Role | Permissions for RDS monitoring | None |
| `aws_iam_role_policy_attachment.rds_monitoring` | Policy Attachment | CloudWatch access for RDS | RDS IAM Role |

### 7. Monitoring Resources

#### CloudWatch Logs
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_cloudwatch_log_group.application` | Log Group | Application logs storage | None |
| `aws_cloudwatch_log_group.rds` | Log Group | RDS logs storage | None |

#### CloudWatch Alarms
| Resource | Type | Purpose | Dependencies |
|----------|------|---------|--------------|
| `aws_cloudwatch_metric_alarm.cpu_high` | Metric Alarm | High CPU utilization alarm | Auto Scaling Group |
| `aws_cloudwatch_metric_alarm.cpu_low` | Metric Alarm | Low CPU utilization alarm | Auto Scaling Group |

## 🔗 Resource Dependencies

### Dependency Graph

```
VPC
├── Subnets (Public, Private, Database)
├── Internet Gateway
├── NAT Gateway
│   └── Elastic IP
├── Route Tables
│   ├── Public Routes
│   └── Private Routes
└── Security Groups

Security Groups
├── ALB Security Group
├── EC2 Security Group
└── RDS Security Group

Load Balancer
├── ALB
├── Target Group
└── Listeners (HTTP/HTTPS)

Compute
├── Launch Template
│   ├── Security Groups
│   └── IAM Role
└── Auto Scaling Group
    ├── Launch Template
    ├── Scaling Policies
    └── CloudWatch Alarms

Database
├── DB Subnet Group
├── DB Parameter Group
└── RDS Instance
    ├── Subnet Group
    ├── Parameter Group
    ├── Security Group
    └── IAM Role (Monitoring)

IAM
├── EC2 Role
│   ├── SSM Policy
│   └── CloudWatch Policy
└── RDS Role
    └── Monitoring Policy

Monitoring
├── CloudWatch Log Groups
└── CloudWatch Alarms
    └── Auto Scaling Group
```

## 📋 Resource Naming Convention

All resources follow a consistent naming pattern:
- **Format**: `${var.project_name}-${resource_type}-${suffix}`
- **Example**: `my-webapp-vpc`, `my-webapp-alb`, `my-webapp-ec2-sg`

### Naming Examples

| Resource Type | Naming Pattern | Example |
|---------------|----------------|---------|
| VPC | `${project_name}-vpc` | `my-webapp-vpc` |
| Subnets | `${project_name}-${tier}-subnet-${index}` | `my-webapp-public-subnet-1` |
| Security Groups | `${project_name}-${service}-sg` | `my-webapp-alb-sg` |
| Load Balancer | `${project_name}-alb` | `my-webapp-alb` |
| Auto Scaling Group | `${project_name}-asg` | `my-webapp-asg` |
| RDS Instance | `${project_name}-rds` | `my-webapp-rds` |

## 🏷️ Tagging Strategy

All resources are tagged with:
- **Name**: Resource-specific name
- **Environment**: From `var.environment`
- **Project**: From `var.project_name`
- **Terraform**: Set to "true"
- **Custom Tags**: From `var.common_tags`

### Tag Examples

```hcl
tags = {
  Name        = "my-webapp-vpc"
  Environment = "prod"
  Project     = "my-webapp"
  Terraform   = "true"
  Owner       = "devops-team"
  CostCenter  = "engineering"
}
```

## 🔒 Security Considerations

### Network Security
- **Public Subnets**: Only ALB and NAT Gateway
- **Private Subnets**: EC2 instances (no direct internet access)
- **Database Subnets**: RDS instances (isolated)

### Security Group Rules
- **ALB**: HTTP/HTTPS from internet, health checks
- **EC2**: HTTP from ALB, SSH from specified CIDRs
- **RDS**: Database port from EC2 security group only

### IAM Least Privilege
- **EC2 Role**: SSM access, CloudWatch logging
- **RDS Role**: Enhanced monitoring only

## 📊 Cost Optimization

### Resource Types by Cost Impact
| High Cost | Medium Cost | Low Cost |
|-----------|-------------|----------|
| NAT Gateway | RDS Instance | VPC/Subnets |
| RDS Storage | ALB | Security Groups |
| EC2 Instances | CloudWatch Logs | IAM Roles |
| | | Route Tables |

### Cost Optimization Features
- **Auto Scaling**: Reduces costs during low traffic
- **RDS Multi-AZ**: Optional for dev environments
- **Log Retention**: Configurable retention periods
- **Instance Types**: Configurable for different workloads

## 🚀 Deployment Phases

### Phase 1: Foundation
1. VPC and networking infrastructure
2. Security groups
3. IAM roles and policies

### Phase 2: Application Layer
1. Launch template
2. Auto Scaling Group
3. Application Load Balancer

### Phase 3: Data Layer
1. RDS subnet group
2. RDS parameter group
3. RDS instance

### Phase 4: Monitoring
1. CloudWatch log groups
2. CloudWatch alarms
3. Auto scaling policies

## 🔧 Maintenance Considerations

### Regular Maintenance
- **AMI Updates**: Launch template version updates
- **Security Patches**: Security group rule reviews
- **Monitoring**: CloudWatch alarm threshold adjustments
- **Backups**: RDS backup retention management

### Scaling Considerations
- **Horizontal Scaling**: Auto Scaling Group policies
- **Vertical Scaling**: Instance type changes
- **Database Scaling**: RDS instance class changes

## 📈 Performance Optimization

### Network Performance
- **Multi-AZ**: RDS and Auto Scaling Group
- **Subnet Distribution**: Across availability zones
- **ALB Health Checks**: Configurable thresholds

### Application Performance
- **Instance Types**: Configurable for workload
- **Auto Scaling**: CPU-based scaling policies
- **Database**: Performance Insights enabled

---

*This resource map provides a comprehensive overview of the AWS infrastructure created by the tfm-aws-webapp module. For detailed configuration options, refer to the module's variables.tf file and examples directory.* 