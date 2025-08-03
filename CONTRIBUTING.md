# Contributing to AWS Web Application Terraform Module

Thank you for your interest in contributing to the AWS Web Application Terraform Module! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Release Process](#release-process)
- [Questions or Problems?](#questions-or-problems)

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues to see if the problem has already been reported. When creating a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps**
- **Explain which behavior you expected to see instead and why**
- **Include details about your configuration and environment**

### Suggesting Enhancements

If you have a suggestion for a new feature or enhancement:

- **Use a clear and descriptive title**
- **Provide a step-by-step description of the suggested enhancement**
- **Provide specific examples to demonstrate the use case**
- **Describe the current behavior and explain which behavior you expected to see instead**

### Pull Requests

- Fork the repository
- Create a feature branch (`git checkout -b feature/amazing-feature`)
- Make your changes
- Add tests for new functionality
- Ensure all tests pass
- Update documentation as needed
- Commit your changes (`git commit -m 'Add some amazing feature'`)
- Push to the branch (`git push origin feature/amazing-feature`)
- Open a Pull Request

## Development Setup

### Prerequisites

- Terraform >= 1.13.0
- AWS CLI configured with appropriate permissions
- Git

### Local Development

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/your-username/tfm-aws-webapp.git
   cd tfm-aws-webapp
   ```

2. **Set up your development environment**
   ```bash
   # Install pre-commit hooks (optional but recommended)
   pre-commit install
   
   # Initialize Terraform
   cd examples/basic
   terraform init
   ```

3. **Run tests**
   ```bash
   # Run Terraform validation
   terraform validate
   
   # Run Terraform format check
   terraform fmt -check
   
   # Run tests (if available)
   terraform test
   ```

## Coding Standards

### Terraform Code Style

- Use consistent indentation (2 spaces)
- Use descriptive variable and resource names
- Include comprehensive descriptions for all variables and outputs
- Use proper validation blocks for variables
- Follow the [Terraform Style Guide](https://www.terraform.io/docs/cloud/run/style-guide.html)

### File Organization

- Keep related resources together
- Use logical file names
- Include proper headers and comments
- Follow the established module structure

### Variable and Output Standards

- All variables must have descriptions
- Use appropriate types and constraints
- Include validation where appropriate
- Mark sensitive variables appropriately
- Provide meaningful default values when possible

### Documentation Standards

- Update README.md for any new features
- Include examples for new functionality
- Update the resource map if new resources are added
- Maintain the changelog for all changes

## Testing Guidelines

### Required Tests

All contributions must include appropriate tests:

1. **Unit Tests**: Test individual resources and data sources
2. **Integration Tests**: Test the complete module deployment
3. **Validation Tests**: Ensure proper variable validation

### Test Structure

```hcl
# tests/basic.tftest.hcl
run "basic_deployment" {
  command = plan
  
  variables {
    project_name = "test-webapp"
    environment  = "test"
    rds_password = "TestPassword123!"
  }
  
  assert {
    condition     = aws_vpc.main.cidr_block == "10.0.0.0/16"
    error_message = "VPC CIDR block should be 10.0.0.0/16"
  }
}
```

### Running Tests

```bash
# Run all tests
terraform test

# Run specific test file
terraform test tests/basic.tftest.hcl

# Run with verbose output
terraform test -verbose
```

## Pull Request Process

### Before Submitting

1. **Ensure your code follows the coding standards**
2. **Add tests for new functionality**
3. **Update documentation**
4. **Run all tests and ensure they pass**
5. **Update the changelog**

### Pull Request Template

Use the following template for pull requests:

```markdown
## Description
Brief description of the changes

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Testing
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

## Checklist
- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
```

### Review Process

1. **Automated Checks**: All PRs must pass automated checks
2. **Code Review**: At least one maintainer must approve
3. **Testing**: All tests must pass
4. **Documentation**: Documentation must be updated

## Release Process

### Versioning

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality in a backward-compatible manner
- **PATCH**: Backward-compatible bug fixes

### Release Steps

1. **Update version numbers**
2. **Update changelog**
3. **Create release branch**
4. **Run full test suite**
5. **Create git tag**
6. **Merge to main**
7. **Publish to Terraform Registry**

## Questions or Problems?

If you have questions or encounter problems:

1. **Check the documentation** in the README and examples
2. **Search existing issues** for similar problems
3. **Create a new issue** with detailed information
4. **Contact maintainers** if needed

## Recognition

Contributors will be recognized in:

- The project README
- Release notes
- The changelog

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to the AWS Web Application Terraform Module! 