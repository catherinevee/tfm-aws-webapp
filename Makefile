# =============================================================================
# Makefile for AWS Dynamic Web Application Terraform Module
# =============================================================================

.PHONY: help init plan apply destroy validate fmt clean test docs

# Default target
help:
	@echo "AWS Dynamic Web Application Terraform Module"
	@echo "=============================================="
	@echo ""
	@echo "Available targets:"
	@echo "  init      - Initialize Terraform"
	@echo "  plan      - Plan Terraform changes"
	@echo "  apply     - Apply Terraform changes"
	@echo "  destroy   - Destroy all resources"
	@echo "  validate  - Validate Terraform configuration"
	@echo "  fmt       - Format Terraform code"
	@echo "  clean     - Clean up temporary files"
	@echo "  test      - Run basic validation tests"
	@echo "  docs      - Generate documentation"
	@echo "  help      - Show this help message"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	terraform init

# Plan Terraform changes
plan:
	@echo "Planning Terraform changes..."
	terraform plan

# Apply Terraform changes
apply:
	@echo "Applying Terraform changes..."
	terraform apply

# Destroy all resources
destroy:
	@echo "Destroying all resources..."
	terraform destroy

# Validate Terraform configuration
validate:
	@echo "Validating Terraform configuration..."
	terraform validate

# Format Terraform code
fmt:
	@echo "Formatting Terraform code..."
	terraform fmt -recursive

# Clean up temporary files
clean:
	@echo "Cleaning up temporary files..."
	rm -rf .terraform
	rm -rf .terraform.lock.hcl
	rm -f terraform.tfstate
	rm -f terraform.tfstate.backup
	rm -f *.tfplan

# Run basic validation tests
test: validate fmt
	@echo "Running validation tests..."
	@echo "✓ Terraform validation passed"
	@echo "✓ Code formatting applied"

# Generate documentation
docs:
	@echo "Generating documentation..."
	@if command -v terraform-docs >/dev/null 2>&1; then \
		terraform-docs markdown table . > README.md.tmp && \
		mv README.md.tmp README.md && \
		echo "✓ Documentation generated"; \
	else \
		echo "⚠️  terraform-docs not found. Install with: go install github.com/terraform-docs/terraform-docs/cmd/terraform-docs@latest"; \
	fi

# Example-specific targets
example-basic:
	@echo "Deploying basic example..."
	cd examples/basic && terraform init && terraform plan

example-advanced:
	@echo "Deploying advanced example..."
	cd examples/advanced && terraform init && terraform plan

# Security and compliance
security-check:
	@echo "Running security checks..."
	@if command -v tflint >/dev/null 2>&1; then \
		tflint --init && tflint; \
	else \
		echo "⚠️  tflint not found. Install with: go install github.com/terraform-linters/tflint/cmd/tflint@latest"; \
	fi

# Cost estimation
cost-estimate:
	@echo "Estimating costs..."
	@if command -v infracost >/dev/null 2>&1; then \
		infracost breakdown --path .; \
	else \
		echo "⚠️  infracost not found. Install with: curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh"; \
	fi

# Backup state
backup:
	@echo "Backing up Terraform state..."
	@if [ -f terraform.tfstate ]; then \
		cp terraform.tfstate terraform.tfstate.backup.$$(date +%Y%m%d_%H%M%S); \
		echo "✓ State backed up"; \
	else \
		echo "⚠️  No terraform.tfstate found"; \
	fi

# Show outputs
outputs:
	@echo "Showing Terraform outputs..."
	terraform output

# Show resources
resources:
	@echo "Showing Terraform resources..."
	terraform state list

# Import example (customize as needed)
import-example:
	@echo "Import example - customize this target for your needs"
	# terraform import module.webapp.aws_vpc.main vpc-12345678

# Workspace management
workspace-dev:
	@echo "Switching to dev workspace..."
	terraform workspace select dev || terraform workspace new dev

workspace-prod:
	@echo "Switching to prod workspace..."
	terraform workspace select prod || terraform workspace new prod

workspace-list:
	@echo "Available workspaces:"
	terraform workspace list

# Module testing
test-module:
	@echo "Testing module..."
	@if command -v terratest >/dev/null 2>&1; then \
		cd test && go test -v -timeout 30m; \
	else \
		echo "⚠️  terratest not found. Install with: go install github.com/gruntwork-io/terratest/modules/terratest@latest"; \
	fi

# CI/CD helpers
ci-init:
	@echo "CI/CD initialization..."
	terraform init -backend=false

ci-plan:
	@echo "CI/CD planning..."
	terraform plan -out=tfplan

ci-apply:
	@echo "CI/CD applying..."
	terraform apply tfplan

# Development helpers
dev-setup:
	@echo "Setting up development environment..."
	@if command -v pre-commit >/dev/null 2>&1; then \
		pre-commit install; \
	else \
		echo "⚠️  pre-commit not found. Install with: pip install pre-commit"; \
	fi

# Show module information
module-info:
	@echo "Module Information"
	@echo "=================="
	@echo "Name: AWS Dynamic Web Application"
	@echo "Version: 1.0.0"
	@echo "Description: Comprehensive Terraform module for web applications"
	@echo "Requirements:"
	@echo "  - Terraform >= 1.0"
	@echo "  - AWS Provider >= 5.0"
	@echo "  - AWS CLI configured" 