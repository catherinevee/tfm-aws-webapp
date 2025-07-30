# =============================================================================
# Variables for Dynamic Web Application Module
# =============================================================================

# =============================================================================
# General Configuration
# =============================================================================

variable "project_name" {
  description = "Name of the project/application"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Project     = "webapp"
  }
}

# =============================================================================
# VPC and Networking
# =============================================================================

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR block."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All public subnet CIDR blocks must be valid."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All private subnet CIDR blocks must be valid."
  }
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]

  validation {
    condition = alltrue([
      for cidr in var.database_subnet_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All database subnet CIDR blocks must be valid."
  }
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway for private subnets"
  type        = bool
  default     = true
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
  default     = ["10.0.0.0/16"]

  validation {
    condition = alltrue([
      for cidr in var.allowed_ssh_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "All SSH CIDR blocks must be valid."
  }
}

# =============================================================================
# Application Load Balancer
# =============================================================================

variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
  default     = false
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS"
  type        = string
  default     = ""

  validation {
    condition     = var.certificate_arn == "" || can(regex("^arn:aws:acm:", var.certificate_arn))
    error_message = "Certificate ARN must be a valid ACM certificate ARN."
  }
}

variable "health_check_path" {
  description = "Path for ALB health checks"
  type        = string
  default     = "/health"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
  default     = false
}

# =============================================================================
# EC2 and Auto Scaling
# =============================================================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^[a-z0-9]+\\.[a-z0-9]+$", var.instance_type))
    error_message = "Instance type must be in the format family.size."
  }
}

variable "min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1

  validation {
    condition     = var.min_size >= 1
    error_message = "Minimum size must be at least 1."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 3

  validation {
    condition     = var.max_size >= var.min_size
    error_message = "Maximum size must be greater than or equal to minimum size."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 2

  validation {
    condition     = var.desired_capacity >= var.min_size && var.desired_capacity <= var.max_size
    error_message = "Desired capacity must be between minimum and maximum size."
  }
}

# =============================================================================
# RDS Database
# =============================================================================

variable "rds_engine" {
  description = "RDS database engine"
  type        = string
  default     = "mysql"

  validation {
    condition     = contains(["mysql", "postgres", "mariadb", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], var.rds_engine)
    error_message = "RDS engine must be a supported database engine."
  }
}

variable "rds_engine_version" {
  description = "RDS database engine version"
  type        = string
  default     = "8.0.35"
}

variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.rds_allocated_storage >= 20
    error_message = "RDS allocated storage must be at least 20 GB."
  }
}

variable "rds_max_allocated_storage" {
  description = "RDS maximum allocated storage in GB"
  type        = number
  default     = 100

  validation {
    condition     = var.rds_max_allocated_storage >= var.rds_allocated_storage
    error_message = "RDS max allocated storage must be greater than or equal to allocated storage."
  }
}

variable "rds_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp2"

  validation {
    condition     = contains(["gp2", "gp3", "io1", "standard"], var.rds_storage_type)
    error_message = "RDS storage type must be one of: gp2, gp3, io1, standard."
  }
}

variable "rds_database_name" {
  description = "RDS database name"
  type        = string
  default     = "webapp"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.rds_database_name))
    error_message = "Database name must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.rds_username))
    error_message = "Username must start with a letter and contain only letters, numbers, and underscores."
  }
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.rds_password) >= 8
    error_message = "RDS password must be at least 8 characters long."
  }
}

variable "rds_port" {
  description = "RDS database port"
  type        = number
  default     = 3306

  validation {
    condition     = var.rds_port >= 1 && var.rds_port <= 65535
    error_message = "RDS port must be between 1 and 65535."
  }
}

variable "rds_backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
  default     = 7

  validation {
    condition     = var.rds_backup_retention_period >= 0 && var.rds_backup_retention_period <= 35
    error_message = "RDS backup retention period must be between 0 and 35 days."
  }
}

variable "rds_backup_window" {
  description = "RDS backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "rds_maintenance_window" {
  description = "RDS maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "rds_multi_az" {
  description = "Enable RDS Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "rds_skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS instance"
  type        = bool
  default     = false
}

variable "rds_deletion_protection" {
  description = "Enable RDS deletion protection"
  type        = bool
  default     = false
}

variable "rds_performance_insights_enabled" {
  description = "Enable RDS Performance Insights"
  type        = bool
  default     = false
}

variable "rds_monitoring_interval" {
  description = "RDS monitoring interval in seconds"
  type        = number
  default     = 60

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.rds_monitoring_interval)
    error_message = "RDS monitoring interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "rds_parameters" {
  description = "RDS parameter group parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# =============================================================================
# Monitoring and Logging
# =============================================================================

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 30

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.log_retention_days)
    error_message = "Log retention days must be one of the allowed values."
  }
} 

# ==============================================================================
# Enhanced Web Application Configuration Variables
# ==============================================================================

variable "webapp_config" {
  description = "Web application configuration"
  type = object({
    enable_auto_scaling = optional(bool, true)
    enable_load_balancing = optional(bool, true)
    enable_ssl_termination = optional(bool, true)
    enable_sticky_sessions = optional(bool, false)
    enable_health_checks = optional(bool, true)
    enable_logging = optional(bool, true)
    enable_monitoring = optional(bool, true)
    enable_backup = optional(bool, true)
    enable_cdn = optional(bool, false)
    enable_waf = optional(bool, false)
    enable_rate_limiting = optional(bool, true)
    enable_caching = optional(bool, true)
    enable_session_storage = optional(bool, true)
    enable_file_upload = optional(bool, false)
    enable_real_time_features = optional(bool, false)
    enable_api_gateway = optional(bool, false)
    enable_websocket_support = optional(bool, false)
    enable_microservices = optional(bool, false)
    enable_container_deployment = optional(bool, false)
    enable_serverless = optional(bool, false)
    enable_blue_green_deployment = optional(bool, false)
    enable_canary_deployment = optional(bool, false)
    enable_rolling_deployment = optional(bool, true)
    enable_immutable_deployment = optional(bool, false)
  })
  default = {}
}

# ==============================================================================
# Enhanced Application Load Balancer Configuration Variables
# ==============================================================================

variable "alb_config" {
  description = "Application Load Balancer configuration"
  type = object({
    name = optional(string, null)
    internal = optional(bool, false)
    load_balancer_type = optional(string, "application")
    enable_deletion_protection = optional(bool, false)
    enable_http2 = optional(bool, true)
    enable_access_logs = optional(bool, true)
    access_logs_bucket = optional(string, null)
    access_logs_prefix = optional(string, null)
    idle_timeout = optional(number, 60)
    enable_cross_zone_load_balancing = optional(bool, true)
    enable_desync_mitigation_mode = optional(string, "defensive")
    enable_http_desync_mitigation_mode = optional(string, "defensive")
    enable_waf_fail_open = optional(bool, false)
    drop_invalid_header_fields = optional(bool, false)
    preserve_host_header = optional(bool, false)
    xff_header_processing_mode = optional(string, "append")
    xff_header_trusted_ips = optional(list(string), [])
    tags = optional(map(string), {})
  })
  default = {}
}

variable "alb_listeners" {
  description = "Map of ALB listeners to create"
  type = map(object({
    load_balancer_arn = string
    port = number
    protocol = string
    ssl_policy = optional(string, null)
    certificate_arn = optional(string, null)
    default_action = object({
      type = string
      target_group_arn = optional(string, null)
      forward = optional(object({
        target_group = list(object({
          arn = string
          weight = optional(number, null)
        }))
        stickiness = optional(object({
          enabled = bool
          duration = number
        }), {})
      }), {})
      redirect = optional(object({
        path = optional(string, null)
        host = optional(string, null)
        port = optional(string, null)
        protocol = optional(string, null)
        query = optional(string, null)
        status_code = string
      }), {})
      fixed_response = optional(object({
        content_type = string
        message_body = optional(string, null)
        status_code = optional(string, null)
      }), {})
      authenticate_cognito = optional(object({
        user_pool_arn = string
        user_pool_client_id = string
        user_pool_domain = string
        scope = optional(string, null)
        session_cookie_name = optional(string, null)
        session_timeout = optional(number, null)
        on_unauthenticated_request = optional(string, null)
      }), {})
      authenticate_oidc = optional(object({
        authorization_endpoint = string
        client_id = string
        client_secret = string
        issuer = string
        token_endpoint = string
        user_info_endpoint = string
        scope = optional(string, null)
        session_cookie_name = optional(string, null)
        session_timeout = optional(number, null)
        on_unauthenticated_request = optional(string, null)
      }), {})
    })
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "alb_target_groups" {
  description = "Map of ALB target groups to create"
  type = map(object({
    name = string
    port = optional(number, 80)
    protocol = optional(string, "HTTP")
    vpc_id = string
    target_type = optional(string, "instance")
    deregistration_delay = optional(number, 300)
    slow_start = optional(number, 0)
    proxy_protocol_v2 = optional(bool, false)
    lambda_multi_value_headers_enabled = optional(bool, false)
    load_balancing_algorithm_type = optional(string, "round_robin")
    stickiness = optional(object({
      type = string
      cookie_duration = optional(number, 86400)
      cookie_name = optional(string, null)
      enabled = optional(bool, true)
    }), {})
    health_check = optional(object({
      enabled = optional(bool, true)
      healthy_threshold = optional(number, 3)
      interval = optional(number, 30)
      matcher = optional(string, "200")
      path = optional(string, "/")
      port = optional(string, "traffic-port")
      protocol = optional(string, "HTTP")
      timeout = optional(number, 5)
      unhealthy_threshold = optional(number, 3)
      success_codes = optional(string, "200")
    }), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "alb_listener_rules" {
  description = "Map of ALB listener rules to create"
  type = map(object({
    listener_arn = string
    priority = optional(number, null)
    action = object({
      type = string
      target_group_arn = optional(string, null)
      forward = optional(object({
        target_group = list(object({
          arn = string
          weight = optional(number, null)
        }))
        stickiness = optional(object({
          enabled = bool
          duration = number
        }), {})
      }), {})
      redirect = optional(object({
        path = optional(string, null)
        host = optional(string, null)
        port = optional(string, null)
        protocol = optional(string, null)
        query = optional(string, null)
        status_code = string
      }), {})
      fixed_response = optional(object({
        content_type = string
        message_body = optional(string, null)
        status_code = optional(string, null)
      }), {})
      authenticate_cognito = optional(object({
        user_pool_arn = string
        user_pool_client_id = string
        user_pool_domain = string
        scope = optional(string, null)
        session_cookie_name = optional(string, null)
        session_timeout = optional(number, null)
        on_unauthenticated_request = optional(string, null)
      }), {})
      authenticate_oidc = optional(object({
        authorization_endpoint = string
        client_id = string
        client_secret = string
        issuer = string
        token_endpoint = string
        user_info_endpoint = string
        scope = optional(string, null)
        session_cookie_name = optional(string, null)
        session_timeout = optional(number, null)
        on_unauthenticated_request = optional(string, null)
      }), {})
    })
    condition = list(object({
      field = optional(string, null)
      host_header = optional(object({
        values = list(string)
      }), {})
      http_header = optional(object({
        http_header_name = string
        values = list(string)
      }), {})
      http_request_method = optional(object({
        values = list(string)
      }), {})
      path_pattern = optional(object({
        values = list(string)
      }), {})
      query_string = optional(list(object({
        key = optional(string, null)
        value = string
      })), [])
      source_ip = optional(object({
        values = list(string)
      }), {})
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# ==============================================================================
# Enhanced Auto Scaling Configuration Variables
# ==============================================================================

variable "autoscaling_config" {
  description = "Auto Scaling configuration"
  type = object({
    enable_auto_scaling = optional(bool, true)
    min_size = optional(number, 1)
    max_size = optional(number, 10)
    desired_capacity = optional(number, 2)
    health_check_grace_period = optional(number, 300)
    health_check_type = optional(string, "ELB")
    force_delete = optional(bool, false)
    termination_policies = optional(list(string), ["Default"])
    suspended_processes = optional(list(string), [])
    placement_group = optional(string, null)
    max_instance_lifetime = optional(number, null)
    wait_for_capacity_timeout = optional(string, "10m")
    min_elb_capacity = optional(number, null)
    wait_for_elb_capacity = optional(number, null)
    protect_from_scale_in = optional(bool, false)
    service_linked_role_arn = optional(string, null)
    enabled_metrics = optional(list(string), [])
    metrics_granularity = optional(string, "1Minute")
    target_tracking_scaling_policy = optional(object({
      predefined_metric_specification = optional(object({
        predefined_metric_type = string
        resource_label = optional(string, null)
      }), {})
      customized_metric_specification = optional(object({
        metric_name = string
        namespace = string
        statistic = string
        unit = optional(string, null)
        dimensions = optional(list(object({
          name = string
          value = string
        })), [])
      }), {})
      target_value = number
      disable_scale_in = optional(bool, false)
    }), {})
    step_scaling_policy = optional(object({
      adjustment_type = string
      cooldown = number
      metric_aggregation_type = string
      min_adjustment_magnitude = optional(number, null)
      step_adjustment = list(object({
        metric_interval_lower_bound = optional(string, null)
        metric_interval_upper_bound = optional(string, null)
        scaling_adjustment = number
      }))
    }), {})
    simple_scaling_policy = optional(object({
      adjustment_type = string
      cooldown = number
      scaling_adjustment = number
    }), {})
    scheduled_action = optional(list(object({
      scheduled_action_name = string
      min_size = optional(number, null)
      max_size = optional(number, null)
      desired_capacity = optional(number, null)
      start_time = optional(string, null)
      end_time = optional(string, null)
      recurrence = optional(string, null)
    })), [])
  })
  default = {}
}

# ==============================================================================
# Enhanced Launch Template Configuration Variables
# ==============================================================================

variable "launch_template_config" {
  description = "Launch template configuration"
  type = object({
    name_prefix = optional(string, null)
    description = optional(string, null)
    update_default_version = optional(bool, true)
    disable_api_termination = optional(bool, false)
    instance_initiated_shutdown_behavior = optional(string, "stop")
    kernel_id = optional(string, null)
    ram_disk_id = optional(string, null)
    instance_type = optional(string, "t3.micro")
    key_name = optional(string, null)
    monitoring = optional(object({
      enabled = bool
    }), {})
    network_interfaces = optional(list(object({
      associate_public_ip_address = optional(bool, null)
      delete_on_termination = optional(bool, null)
      description = optional(string, null)
      device_index = optional(number, null)
      interface_type = optional(string, null)
      ipv4_address_count = optional(number, null)
      ipv4_addresses = optional(list(string), [])
      ipv6_address_count = optional(number, null)
      ipv6_addresses = optional(list(string), [])
      network_card_index = optional(number, null)
      network_interface_id = optional(string, null)
      private_ip_address = optional(string, null)
      security_groups = optional(list(string), [])
      subnet_id = optional(string, null)
    })), [])
    placement = optional(object({
      affinity = optional(string, null)
      availability_zone = optional(string, null)
      group_name = optional(string, null)
      host_id = optional(string, null)
      host_resource_group_arn = optional(string, null)
      partition_number = optional(number, null)
      spread_domain = optional(string, null)
      tenancy = optional(string, null)
    }), {})
    block_device_mappings = optional(list(object({
      device_name = optional(string, null)
      ebs = optional(object({
        delete_on_termination = optional(bool, null)
        encrypted = optional(bool, null)
        iops = optional(number, null)
        kms_key_id = optional(string, null)
        snapshot_id = optional(string, null)
        throughput = optional(number, null)
        volume_size = optional(number, null)
        volume_type = optional(string, null)
      }), {})
      no_device = optional(string, null)
      virtual_name = optional(string, null)
    })), [])
    capacity_reservation_specification = optional(object({
      capacity_reservation_preference = optional(string, null)
      capacity_reservation_target = optional(object({
        capacity_reservation_id = optional(string, null)
        capacity_reservation_resource_group_arn = optional(string, null)
      }), {})
    }), {})
    cpu_options = optional(object({
      core_count = optional(number, null)
      threads_per_core = optional(number, null)
    }), {})
    credit_specification = optional(object({
      cpu_credits = optional(string, null)
    }), {})
    elastic_gpu_specifications = optional(list(object({
      type = string
    })), [])
    elastic_inference_accelerator = optional(object({
      type = string
    }), {})
    enclave_options = optional(object({
      enabled = bool
    }), {})
    hibernation_options = optional(object({
      configured = bool
    }), {})
    instance_market_options = optional(object({
      market_type = optional(string, null)
      spot_options = optional(object({
        block_duration_minutes = optional(number, null)
        instance_interruption_behavior = optional(string, null)
        max_price = optional(string, null)
        spot_instance_type = optional(string, null)
        valid_until = optional(string, null)
      }), {})
    }), {})
    instance_requirements = optional(object({
      accelerator_count = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      accelerator_manufacturers = optional(list(string), [])
      accelerator_names = optional(list(string), [])
      accelerator_total_memory_mib = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      accelerator_types = optional(list(string), [])
      allowed_instance_types = optional(list(string), [])
      bare_metal = optional(string, null)
      baseline_ebs_bandwidth_mbps = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      burstable_performance = optional(string, null)
      cpu_manufacturers = optional(list(string), [])
      excluded_instance_types = optional(list(string), [])
      instance_generations = optional(list(string), [])
      local_storage = optional(string, null)
      local_storage_types = optional(list(string), [])
      max_spot_price_as_percentage_of_optimal_on_demand_price = optional(number, null)
      memory_gib_per_vcpu = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      memory_mib = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      network_bandwidth_gbps = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      network_interface_count = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      on_demand_max_price_percentage_over_lowest_price = optional(number, null)
      require_hibernate_support = optional(bool, null)
      spot_max_price_percentage_over_lowest_price = optional(number, null)
      total_local_storage_gb = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
      vcpu_count = optional(object({
        max = optional(number, null)
        min = optional(number, null)
      }), {})
    }), {})
    license_specification = optional(list(object({
      license_configuration_arn = string
    })), [])
    maintenance_options = optional(object({
      auto_recovery = optional(string, null)
    }), {})
    metadata_options = optional(object({
      http_endpoint = optional(string, null)
      http_put_response_hop_limit = optional(number, null)
      http_tokens = optional(string, null)
      instance_metadata_tags = optional(string, null)
    }), {})
    private_dns_name_options = optional(object({
      enable_resource_name_dns_a_record = optional(bool, null)
      enable_resource_name_dns_aaaa_record = optional(bool, null)
      hostname_type = optional(string, null)
    }), {})
    tag_specifications = optional(list(object({
      resource_type = string
      tags = optional(map(string), {})
    })), [])
    vpc_security_group_ids = optional(list(string), [])
    user_data = optional(string, null)
    tags = optional(map(string), {})
  })
  default = {}
}

# ==============================================================================
# Enhanced CloudWatch Configuration Variables
# ==============================================================================

variable "cloudwatch_config" {
  description = "CloudWatch configuration"
  type = object({
    enable_detailed_monitoring = optional(bool, true)
    enable_log_aggregation = optional(bool, true)
    enable_custom_metrics = optional(bool, true)
    enable_dashboard = optional(bool, true)
    enable_alarms = optional(bool, true)
    log_retention_days = optional(number, 30)
    metric_namespace = optional(string, "WebApp")
    dashboard_name = optional(string, null)
    dashboard_body = optional(string, null)
    alarms = optional(list(object({
      name = string
      comparison_operator = string
      evaluation_periods = number
      metric_name = string
      namespace = string
      period = number
      statistic = string
      threshold = number
      alarm_description = optional(string, null)
      alarm_actions = optional(list(string), [])
      insufficient_data_actions = optional(list(string), [])
      ok_actions = optional(list(string), [])
      unit = optional(string, null)
      extended_statistic = optional(string, null)
      treat_missing_data = optional(string, "missing")
      evaluate_low_sample_count_percentiles = optional(string, null)
      threshold_metric_id = optional(string, null)
      datapoints_to_alarm = optional(number, null)
      tags = optional(map(string), {})
    })), [])
  })
  default = {}
}

# ==============================================================================
# Enhanced Application Configuration Variables
# ==============================================================================

variable "application_config" {
  description = "Application configuration"
  type = object({
    app_name = optional(string, null)
    app_version = optional(string, "1.0.0")
    app_environment = optional(string, "production")
    app_port = optional(number, 80)
    app_protocol = optional(string, "HTTP")
    app_health_check_path = optional(string, "/health")
    app_health_check_port = optional(number, 80)
    app_health_check_protocol = optional(string, "HTTP")
    app_health_check_interval = optional(number, 30)
    app_health_check_timeout = optional(number, 5)
    app_health_check_healthy_threshold = optional(number, 3)
    app_health_check_unhealthy_threshold = optional(number, 3)
    app_health_check_success_codes = optional(string, "200")
    app_health_check_matcher = optional(string, "200")
    app_health_check_grace_period = optional(number, 300)
    app_health_check_type = optional(string, "ELB")
    app_force_new_deployment = optional(bool, false)
    app_wait_for_steady_state = optional(bool, true)
    app_enable_execute_command = optional(bool, false)
    app_enable_ecs_managed_tags = optional(bool, false)
    app_propagate_tags = optional(string, null)
    app_health_check_grace_period_seconds = optional(number, null)
    app_capacity_provider_strategy = optional(list(object({
      capacity_provider = string
      weight = optional(number, null)
      base = optional(number, null)
    })), [])
    app_network_configuration = optional(object({
      subnets = list(string)
      security_groups = optional(list(string), [])
      assign_public_ip = optional(bool, null)
    }), {})
    app_load_balancer = optional(list(object({
      elb_name = optional(string, null)
      target_group_arn = optional(string, null)
      container_name = string
      container_port = number
    })), [])
    app_service_registries = optional(list(object({
      registry_arn = string
      port = optional(number, null)
      container_port = optional(number, null)
      container_name = optional(string, null)
    })), [])
    app_deployment_circuit_breaker = optional(object({
      enable = bool
      rollback = bool
    }), {})
    app_deployment_controller = optional(object({
      type = string
    }), {})
    app_deployment_maximum_percent = optional(number, null)
    app_deployment_minimum_healthy_percent = optional(number, null)
    app_desired_count = optional(number, null)
    app_enable_ecs_managed_tags = optional(bool, null)
    app_health_check_grace_period_seconds = optional(number, null)
    app_iam_role = optional(string, null)
    app_load_balancer = optional(list(object({
      elb_name = optional(string, null)
      target_group_arn = optional(string, null)
      container_name = string
      container_port = number
    })), [])
    app_network_configuration = optional(object({
      subnets = list(string)
      security_groups = optional(list(string), [])
      assign_public_ip = optional(bool, null)
    }), {})
    app_ordered_placement_strategy = optional(list(object({
      type = string
      field = optional(string, null)
    })), [])
    app_placement_constraints = optional(list(object({
      type = string
      expression = optional(string, null)
    })), [])
    app_platform_version = optional(string, null)
    app_propagate_tags = optional(string, null)
    app_service_registries = optional(list(object({
      registry_arn = string
      port = optional(number, null)
      container_port = optional(number, null)
      container_name = optional(string, null)
    })), [])
    app_tags = optional(map(string), {})
    app_task_definition = string
    app_wait_for_steady_state = optional(bool, null)
  })
  default = {}
}

# ==============================================================================
# Enhanced Security Configuration Variables
# ==============================================================================

variable "security_config" {
  description = "Security configuration"
  type = object({
    enable_ssl = optional(bool, true)
    enable_waf = optional(bool, false)
    enable_shield = optional(bool, false)
    enable_ddos_protection = optional(bool, false)
    enable_fraud_detection = optional(bool, false)
    enable_pci_compliance = optional(bool, false)
    enable_gdpr_compliance = optional(bool, false)
    enable_data_encryption = optional(bool, true)
    enable_audit_logging = optional(bool, true)
    enable_backup_encryption = optional(bool, true)
    enable_multi_factor_auth = optional(bool, false)
    enable_session_management = optional(bool, true)
    enable_rate_limiting = optional(bool, true)
    enable_ip_whitelisting = optional(bool, false)
    enable_geolocation_restrictions = optional(bool, false)
    enable_content_security_policy = optional(bool, true)
    enable_strict_transport_security = optional(bool, true)
    enable_x_frame_options = optional(bool, true)
    enable_x_content_type_options = optional(bool, true)
    enable_x_xss_protection = optional(bool, true)
    enable_referrer_policy = optional(bool, true)
    enable_feature_policy = optional(bool, true)
    enable_permissions_policy = optional(bool, true)
    enable_expect_ct = optional(bool, false)
    enable_public_key_pinning = optional(bool, false)
    enable_subresource_integrity = optional(bool, false)
    enable_cross_origin_embedder_policy = optional(bool, false)
    enable_cross_origin_opener_policy = optional(bool, false)
    enable_cross_origin_resource_policy = optional(bool, false)
    enable_origin_agent_cluster = optional(bool, false)
    enable_permissions_policy = optional(bool, true)
  })
  default = {}
}

# ==============================================================================
# Enhanced Performance Configuration Variables
# ==============================================================================

variable "performance_config" {
  description = "Performance configuration"
  type = object({
    enable_caching = optional(bool, true)
    enable_cdn = optional(bool, false)
    enable_compression = optional(bool, true)
    enable_minification = optional(bool, true)
    enable_image_optimization = optional(bool, true)
    enable_lazy_loading = optional(bool, true)
    enable_preloading = optional(bool, true)
    enable_prefetching = optional(bool, true)
    enable_prerendering = optional(bool, false)
    enable_service_worker = optional(bool, false)
    enable_http2 = optional(bool, true)
    enable_http3 = optional(bool, false)
    enable_quic = optional(bool, false)
    enable_brotli_compression = optional(bool, true)
    enable_gzip_compression = optional(bool, true)
    enable_deflate_compression = optional(bool, false)
    enable_keep_alive = optional(bool, true)
    enable_connection_pooling = optional(bool, true)
    enable_database_connection_pooling = optional(bool, true)
    enable_redis_caching = optional(bool, false)
    enable_memcached_caching = optional(bool, false)
    enable_elasticache = optional(bool, false)
    enable_cloudfront = optional(bool, false)
    enable_route53_latency_based_routing = optional(bool, false)
    enable_route53_geolocation_routing = optional(bool, false)
    enable_route53_weighted_routing = optional(bool, false)
    enable_route53_failover_routing = optional(bool, false)
    enable_route53_multivalue_routing = optional(bool, false)
    enable_route53_simple_routing = optional(bool, true)
  })
  default = {}
}

# ==============================================================================
# Enhanced Monitoring Configuration Variables
# ==============================================================================

variable "monitoring_config" {
  description = "Monitoring configuration"
  type = object({
    enable_cloudwatch_monitoring = optional(bool, true)
    enable_cloudwatch_logs = optional(bool, true)
    enable_cloudwatch_metrics = optional(bool, true)
    enable_cloudwatch_alarms = optional(bool, true)
    enable_cloudwatch_dashboard = optional(bool, true)
    enable_cloudwatch_insights = optional(bool, false)
    enable_cloudwatch_anomaly_detection = optional(bool, false)
    enable_cloudwatch_rum = optional(bool, false)
    enable_cloudwatch_evidently = optional(bool, false)
    enable_cloudwatch_application_signals = optional(bool, false)
    enable_cloudwatch_synthetics = optional(bool, false)
    enable_cloudwatch_contributor_insights = optional(bool, false)
    enable_cloudwatch_metric_streams = optional(bool, false)
    enable_cloudwatch_metric_filters = optional(bool, false)
    enable_cloudwatch_log_groups = optional(bool, true)
    enable_cloudwatch_log_streams = optional(bool, true)
    enable_cloudwatch_log_subscriptions = optional(bool, false)
    enable_cloudwatch_log_insights = optional(bool, false)
    enable_cloudwatch_log_metric_filters = optional(bool, false)
    enable_cloudwatch_log_destinations = optional(bool, false)
    enable_cloudwatch_log_queries = optional(bool, false)
    enable_cloudwatch_log_analytics = optional(bool, false)
    enable_cloudwatch_log_visualization = optional(bool, false)
    enable_cloudwatch_log_reporting = optional(bool, false)
    enable_cloudwatch_log_archiving = optional(bool, false)
    enable_cloudwatch_log_backup = optional(bool, false)
    enable_cloudwatch_log_retention = optional(bool, true)
    enable_cloudwatch_log_encryption = optional(bool, true)
    enable_cloudwatch_log_access_logging = optional(bool, false)
    enable_cloudwatch_log_audit_logging = optional(bool, false)
    enable_cloudwatch_log_compliance_logging = optional(bool, false)
    enable_cloudwatch_log_security_logging = optional(bool, false)
    enable_cloudwatch_log_performance_logging = optional(bool, true)
    enable_cloudwatch_log_business_logging = optional(bool, false)
    enable_cloudwatch_log_operational_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_trace_logging = optional(bool, false)
    enable_cloudwatch_log_error_logging = optional(bool, true)
    enable_cloudwatch_log_warning_logging = optional(bool, true)
    enable_cloudwatch_log_info_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_verbose_logging = optional(bool, false)
    enable_cloudwatch_log_silent_logging = optional(bool, false)
  })
  default = {}
} 