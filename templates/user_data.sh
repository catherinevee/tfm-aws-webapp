#!/bin/bash

# =============================================================================
# User Data Script for Dynamic Web Application
# =============================================================================
# This script is executed when EC2 instances are launched
# It installs and configures the web application stack

set -e

# =============================================================================
# Variables
# =============================================================================

PROJECT_NAME="${project_name}"
RDS_ENDPOINT="${rds_endpoint}"
RDS_PORT="${rds_port}"
RDS_NAME="${rds_name}"
RDS_USERNAME="${rds_username}"
RDS_PASSWORD="${rds_password}"

# =============================================================================
# System Updates and Package Installation
# =============================================================================

echo "Starting system updates and package installation..."

# Update system packages
yum update -y

# Install required packages
yum install -y \
    httpd \
    php \
    php-mysql \
    php-json \
    php-mbstring \
    php-xml \
    php-curl \
    php-gd \
    php-zip \
    mysql \
    git \
    unzip \
    wget \
    curl \
    jq \
    amazon-cloudwatch-agent

# Enable and start Apache
systemctl enable httpd
systemctl start httpd

# =============================================================================
# Configure Apache
# =============================================================================

echo "Configuring Apache..."

# Create Apache configuration
cat > /etc/httpd/conf.d/webapp.conf << 'EOF'
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog logs/webapp_error.log
    CustomLog logs/webapp_access.log combined
</VirtualHost>
EOF

# Enable required Apache modules
a2enmod rewrite
a2enmod headers

# =============================================================================
# Configure PHP
# =============================================================================

echo "Configuring PHP..."

# Create PHP configuration
cat > /etc/php.ini << 'EOF'
[PHP]
memory_limit = 256M
max_execution_time = 300
upload_max_filesize = 64M
post_max_size = 64M
display_errors = Off
log_errors = On
error_log = /var/log/php_errors.log
date.timezone = UTC

[Date]
date.timezone = UTC
EOF

# =============================================================================
# Create Web Application
# =============================================================================

echo "Creating web application..."

# Create application directory
mkdir -p /var/www/html

# Create a simple PHP web application
cat > /var/www/html/index.php << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dynamic Web Application</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-card {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            border-left: 4px solid #007bff;
        }
        .info-card h3 {
            margin-top: 0;
            color: #007bff;
        }
        .status {
            padding: 10px;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
        }
        .status.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            color: #666;
            font-size: 0.9em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Dynamic Web Application</h1>
            <p>Powered by AWS EC2 + ALB + RDS</p>
        </div>

        <div class="info-grid">
            <div class="info-card">
                <h3>📊 System Information</h3>
                <p><strong>Server:</strong> <?php echo $_SERVER['SERVER_NAME']; ?></p>
                <p><strong>Instance ID:</strong> <?php echo file_get_contents('http://169.254.169.254/latest/meta-data/instance-id'); ?></p>
                <p><strong>Availability Zone:</strong> <?php echo file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone'); ?></p>
                <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
                <p><strong>Server Time:</strong> <?php echo date('Y-m-d H:i:s T'); ?></p>
            </div>

            <div class="info-card">
                <h3>🗄️ Database Status</h3>
                <?php
                $db_status = 'Unknown';
                $db_error = '';
                
                try {
                    $pdo = new PDO(
                        "mysql:host=<?php echo $RDS_ENDPOINT; ?>;port=<?php echo $RDS_PORT; ?>;dbname=<?php echo $RDS_NAME; ?>",
                        '<?php echo $RDS_USERNAME; ?>',
                        '<?php echo $RDS_PASSWORD; ?>',
                        array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
                    );
                    $db_status = 'Connected';
                } catch (PDOException $e) {
                    $db_status = 'Error';
                    $db_error = $e->getMessage();
                }
                ?>
                <p><strong>Status:</strong> 
                    <span class="status <?php echo $db_status === 'Connected' ? 'success' : 'error'; ?>">
                        <?php echo $db_status; ?>
                    </span>
                </p>
                <p><strong>Host:</strong> <?php echo $RDS_ENDPOINT; ?></p>
                <p><strong>Database:</strong> <?php echo $RDS_NAME; ?></p>
                <?php if ($db_error): ?>
                    <p><strong>Error:</strong> <?php echo htmlspecialchars($db_error); ?></p>
                <?php endif; ?>
            </div>

            <div class="info-card">
                <h3>🔧 Application Features</h3>
                <p>✅ Auto Scaling Group</p>
                <p>✅ Application Load Balancer</p>
                <p>✅ RDS Database</p>
                <p>✅ CloudWatch Monitoring</p>
                <p>✅ Security Groups</p>
                <p>✅ IAM Roles</p>
            </div>

            <div class="info-card">
                <h3>📈 Performance</h3>
                <p><strong>Memory Usage:</strong> <?php echo round(memory_get_usage(true) / 1024 / 1024, 2); ?> MB</p>
                <p><strong>Peak Memory:</strong> <?php echo round(memory_get_peak_usage(true) / 1024 / 1024, 2); ?> MB</p>
                <p><strong>Load Average:</strong> <?php echo sys_getloadavg()[0]; ?></p>
                <p><strong>Uptime:</strong> <?php echo exec('uptime -p'); ?></p>
            </div>
        </div>

        <div class="footer">
            <p>Built with Terraform | Deployed on AWS | <?php echo date('Y'); ?></p>
        </div>
    </div>
</body>
</html>
EOF

# Create health check endpoint
cat > /var/www/html/health.php << 'EOF'
<?php
header('Content-Type: application/json');

$health = array(
    'status' => 'healthy',
    'timestamp' => date('c'),
    'instance_id' => file_get_contents('http://169.254.169.254/latest/meta-data/instance-id'),
    'availability_zone' => file_get_contents('http://169.254.169.254/latest/meta-data/placement/availability-zone'),
    'checks' => array()
);

// Database connectivity check
try {
    $pdo = new PDO(
        "mysql:host=<?php echo $RDS_ENDPOINT; ?>;port=<?php echo $RDS_PORT; ?>;dbname=<?php echo $RDS_NAME; ?>",
        '<?php echo $RDS_USERNAME; ?>',
        '<?php echo $RDS_PASSWORD; ?>',
        array(PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION)
    );
    $health['checks']['database'] = 'healthy';
} catch (Exception $e) {
    $health['checks']['database'] = 'unhealthy';
    $health['status'] = 'unhealthy';
}

// Apache service check
if (function_exists('exec')) {
    $apache_status = exec('systemctl is-active httpd');
    $health['checks']['apache'] = $apache_status === 'active' ? 'healthy' : 'unhealthy';
    if ($apache_status !== 'active') {
        $health['status'] = 'unhealthy';
    }
}

// Memory check
$memory_limit = ini_get('memory_limit');
$memory_usage = memory_get_usage(true);
$health['checks']['memory'] = 'healthy';
$health['memory_usage_mb'] = round($memory_usage / 1024 / 1024, 2);

echo json_encode($health, JSON_PRETTY_PRINT);
?>
EOF

# Create a simple health check endpoint
cat > /var/www/html/health << 'EOF'
OK
EOF

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

# =============================================================================
# Configure CloudWatch Agent
# =============================================================================

echo "Configuring CloudWatch Agent..."

# Create CloudWatch agent configuration
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "agent": {
        "metrics_collection_interval": 60,
        "run_as_user": "root"
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/httpd/access_log",
                        "log_group_name": "/aws/ec2/<?php echo $PROJECT_NAME; ?>",
                        "log_stream_name": "{instance_id}/apache/access",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "/aws/ec2/<?php echo $PROJECT_NAME; ?>",
                        "log_stream_name": "{instance_id}/apache/error",
                        "timezone": "UTC"
                    },
                    {
                        "file_path": "/var/log/php_errors.log",
                        "log_group_name": "/aws/ec2/<?php echo $PROJECT_NAME; ?>",
                        "log_stream_name": "{instance_id}/php/errors",
                        "timezone": "UTC"
                    }
                ]
            }
        }
    },
    "metrics": {
        "namespace": "WebApp/EC2",
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_iowait", "cpu_usage_user", "cpu_usage_system"],
                "metrics_collection_interval": 60,
                "totalcpu": false
            },
            "disk": {
                "measurement": ["used_percent"],
                "metrics_collection_interval": 60,
                "resources": ["*"]
            },
            "diskio": {
                "measurement": ["io_time"],
                "metrics_collection_interval": 60,
                "resources": ["*"]
            },
            "mem": {
                "measurement": ["mem_used_percent"],
                "metrics_collection_interval": 60
            },
            "netstat": {
                "measurement": ["tcp_established", "tcp_time_wait"],
                "metrics_collection_interval": 60
            },
            "swap": {
                "measurement": ["swap_used_percent"],
                "metrics_collection_interval": 60
            }
        }
    }
}
EOF

# Start CloudWatch agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# =============================================================================
# Security Hardening
# =============================================================================

echo "Applying security hardening..."

# Disable Apache server signature
echo "ServerTokens Prod" >> /etc/httpd/conf/httpd.conf
echo "ServerSignature Off" >> /etc/httpd/conf/httpd.conf

# Configure firewall (if available)
if command -v firewall-cmd &> /dev/null; then
    firewall-cmd --permanent --add-service=http
    firewall-cmd --permanent --add-service=https
    firewall-cmd --reload
fi

# =============================================================================
# Final Configuration
# =============================================================================

echo "Finalizing configuration..."

# Restart Apache to apply all changes
systemctl restart httpd

# Create a simple status file
echo "Web application deployed successfully at $(date)" > /var/www/html/status.txt

# Log deployment completion
echo "Web application deployment completed at $(date)" >> /var/log/webapp-deployment.log

echo "=========================================="
echo "Web Application Deployment Complete!"
echo "=========================================="
echo "Project: $PROJECT_NAME"
echo "Database: $RDS_ENDPOINT"
echo "Health Check: http://localhost/health"
echo "==========================================" 