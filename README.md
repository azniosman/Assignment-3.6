# Assignment 3.6 - Terraform, GitHub Actions, and Snyk

This repository demonstrates the use of Terraform for infrastructure as code, GitHub Actions for CI/CD, and Snyk for security scanning.

## Architecture

The Terraform configuration in this repository creates:
- An AWS Lambda function that prints "Hello, World!"
- The necessary IAM roles and policies for the Lambda function

## GitHub Actions Workflow

The GitHub Actions workflow in this repository includes:
- Initial checks
- Terraform checks (format, validation, linting)
- Snyk security checks (code, dependencies, IaC)
- A summary job that reports the status of all checks

## Branch Protection

The main branch is protected and requires pull requests to be approved before merging.

## Setup

1. Clone this repository
2. Configure AWS credentials
3. Run `terraform init` and `terraform apply` in the terraform directory
4. Create a Snyk account and add the SNYK_TOKEN secret to your GitHub repository

## Usage

1. Create a new branch
2. Make changes
3. Push the branch and create a pull request
4. The GitHub Actions workflow will run automatically
5. Once the checks pass and the pull request is approved, it can be merged into the main branch
