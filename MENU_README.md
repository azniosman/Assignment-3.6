# Terraform AWS Provisioning Menu

This is a menu-driven script to help manage your Terraform AWS provisioning. It provides a user-friendly interface for common Terraform operations.

## Features

- Check AWS credentials
- Initialize Terraform
- Validate Terraform configuration
- Plan Terraform changes
- Apply Terraform changes
- Destroy Terraform resources
- Show Terraform outputs
- Format Terraform files
- Workspace management
- Run TFLint for code quality checks
- Show Lambda function details
- Invoke Lambda function

## Prerequisites

- Bash shell
- Terraform installed
- AWS CLI installed (for Lambda function operations)
- TFLint (optional, can be installed through the script)

## Usage

1. Make the script executable:
   ```
   chmod +x terraform_menu.sh
   ```

2. Run the script:
   ```
   ./terraform_menu.sh
   ```

3. Follow the on-screen menu to perform various Terraform operations.

## Menu Options

1. **Check AWS Credentials**: Verify if AWS credentials are configured and set them if needed.
2. **Initialize Terraform**: Run `terraform init` to initialize the working directory.
3. **Validate Terraform Configuration**: Run `terraform validate` to check if the configuration is valid.
4. **Plan Terraform Changes**: Run `terraform plan` to see what changes would be made.
5. **Apply Terraform Changes**: Run `terraform apply` to create or update infrastructure.
6. **Destroy Terraform Resources**: Run `terraform destroy` to destroy all resources.
7. **Show Terraform Outputs**: Display the outputs from the Terraform state.
8. **Format Terraform Files**: Run `terraform fmt` to format the configuration files.
9. **Workspace Management**: Create, select, or view Terraform workspaces.
10. **Run TFLint**: Run TFLint to check for possible errors or best practices.
11. **Show Lambda Function Details**: Display details about the deployed Lambda function.
12. **Invoke Lambda Function**: Invoke the Lambda function with a custom payload.

## Workspace Management

The workspace management submenu allows you to:
1. Show the current workspace
2. Create a new workspace
3. Select an existing workspace

## Notes

- The script assumes that your Terraform configuration is in a directory named `terraform`.
- For Lambda function operations, you need to have the AWS CLI installed and configured.
- The script uses color coding for better readability.
