#!/bin/bash

# Colors for better readability
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display the header
display_header() {
    clear
    echo -e "${BLUE}=========================================================${NC}"
    echo -e "${BLUE}           Terraform AWS Provisioning Menu               ${NC}"
    echo -e "${BLUE}=========================================================${NC}"
    echo ""
}

# Function to check if AWS credentials are configured
check_aws_credentials() {
    if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo -e "${YELLOW}AWS credentials not found in environment variables.${NC}"
        echo -e "${YELLOW}You may need to configure AWS credentials before deploying.${NC}"
        echo ""
        echo -e "Would you like to configure AWS credentials now? (y/n)"
        read -r configure_aws
        
        if [[ $configure_aws == "y" || $configure_aws == "Y" ]]; then
            echo -e "Enter your AWS Access Key ID:"
            read -r aws_access_key
            echo -e "Enter your AWS Secret Access Key:"
            read -r aws_secret_key
            echo -e "Enter your preferred AWS region (default: us-east-1):"
            read -r aws_region
            
            if [ -z "$aws_region" ]; then
                aws_region="us-east-1"
            fi
            
            export AWS_ACCESS_KEY_ID=$aws_access_key
            export AWS_SECRET_ACCESS_KEY=$aws_secret_key
            export AWS_DEFAULT_REGION=$aws_region
            
            echo -e "${GREEN}AWS credentials configured successfully!${NC}"
        else
            echo -e "${YELLOW}Skipping AWS credentials configuration.${NC}"
            echo -e "${YELLOW}Note: You may encounter errors when trying to deploy resources.${NC}"
        fi
    else
        echo -e "${GREEN}AWS credentials found in environment variables.${NC}"
    fi
}

# Function to initialize Terraform
initialize_terraform() {
    echo -e "${BLUE}Initializing Terraform...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform init
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Terraform initialized successfully!${NC}"
    else
        echo -e "${RED}Error initializing Terraform.${NC}"
    fi
    cd ..
}

# Function to validate Terraform configuration
validate_terraform() {
    echo -e "${BLUE}Validating Terraform configuration...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform validate
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Terraform configuration is valid!${NC}"
    else
        echo -e "${RED}Error validating Terraform configuration.${NC}"
    fi
    cd ..
}

# Function to plan Terraform changes
plan_terraform() {
    echo -e "${BLUE}Planning Terraform changes...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform plan
    cd ..
}

# Function to apply Terraform changes
apply_terraform() {
    echo -e "${BLUE}Applying Terraform changes...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    
    echo -e "${YELLOW}Do you want to auto-approve the changes? (y/n)${NC}"
    read -r auto_approve
    
    if [[ $auto_approve == "y" || $auto_approve == "Y" ]]; then
        terraform apply -auto-approve
    else
        terraform apply
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Terraform changes applied successfully!${NC}"
    else
        echo -e "${RED}Error applying Terraform changes.${NC}"
    fi
    cd ..
}

# Function to destroy Terraform resources
destroy_terraform() {
    echo -e "${RED}WARNING: This will destroy all resources created by Terraform.${NC}"
    echo -e "${YELLOW}Are you sure you want to continue? (y/n)${NC}"
    read -r confirm_destroy
    
    if [[ $confirm_destroy == "y" || $confirm_destroy == "Y" ]]; then
        echo -e "${BLUE}Destroying Terraform resources...${NC}"
        cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
        
        echo -e "${YELLOW}Do you want to auto-approve the destruction? (y/n)${NC}"
        read -r auto_approve
        
        if [[ $auto_approve == "y" || $auto_approve == "Y" ]]; then
            terraform destroy -auto-approve
        else
            terraform destroy
        fi
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}Terraform resources destroyed successfully!${NC}"
        else
            echo -e "${RED}Error destroying Terraform resources.${NC}"
        fi
        cd ..
    else
        echo -e "${BLUE}Destruction cancelled.${NC}"
    fi
}

# Function to show Terraform outputs
show_outputs() {
    echo -e "${BLUE}Showing Terraform outputs...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform output
    cd ..
}

# Function to format Terraform files
format_terraform() {
    echo -e "${BLUE}Formatting Terraform files...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform fmt -recursive
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Terraform files formatted successfully!${NC}"
    else
        echo -e "${RED}Error formatting Terraform files.${NC}"
    fi
    cd ..
}

# Function to show Terraform workspace
show_workspace() {
    echo -e "${BLUE}Current Terraform workspace:${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform workspace show
    cd ..
}

# Function to create a new Terraform workspace
create_workspace() {
    echo -e "${BLUE}Enter the name of the new workspace:${NC}"
    read -r workspace_name
    
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform workspace new "$workspace_name"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Workspace '$workspace_name' created and selected successfully!${NC}"
    else
        echo -e "${RED}Error creating workspace '$workspace_name'.${NC}"
    fi
    cd ..
}

# Function to select a Terraform workspace
select_workspace() {
    echo -e "${BLUE}Available workspaces:${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    terraform workspace list
    
    echo -e "${BLUE}Enter the name of the workspace to select:${NC}"
    read -r workspace_name
    
    terraform workspace select "$workspace_name"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Workspace '$workspace_name' selected successfully!${NC}"
    else
        echo -e "${RED}Error selecting workspace '$workspace_name'.${NC}"
    fi
    cd ..
}

# Function to run Terraform lint
run_tflint() {
    echo -e "${BLUE}Running TFLint...${NC}"
    
    # Check if TFLint is installed
    if ! command -v tflint &> /dev/null; then
        echo -e "${YELLOW}TFLint is not installed. Would you like to install it? (y/n)${NC}"
        read -r install_tflint
        
        if [[ $install_tflint == "y" || $install_tflint == "Y" ]]; then
            echo -e "${BLUE}Installing TFLint...${NC}"
            curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
            if [ $? -ne 0 ]; then
                echo -e "${RED}Error installing TFLint.${NC}"
                return 1
            fi
        else
            echo -e "${YELLOW}Skipping TFLint installation.${NC}"
            return 0
        fi
    fi
    
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    tflint --init
    tflint
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}TFLint completed successfully!${NC}"
    else
        echo -e "${YELLOW}TFLint found issues in your Terraform configuration.${NC}"
    fi
    cd ..
}

# Function to show Lambda function details
show_lambda_details() {
    echo -e "${BLUE}Showing Lambda function details...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    
    # Check if the Lambda function exists
    lambda_name=$(terraform output -raw lambda_function_name 2>/dev/null)
    
    if [ $? -ne 0 ] || [ -z "$lambda_name" ]; then
        echo -e "${YELLOW}Lambda function not deployed yet or output not available.${NC}"
        cd ..
        return 1
    fi
    
    echo -e "${GREEN}Lambda Function Name: $lambda_name${NC}"
    echo -e "${BLUE}Fetching Lambda function details from AWS...${NC}"
    
    # Use AWS CLI to get Lambda function details
    aws lambda get-function --function-name "$lambda_name" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Lambda function details retrieved successfully!${NC}"
    else
        echo -e "${RED}Error retrieving Lambda function details.${NC}"
        echo -e "${YELLOW}Make sure you have AWS CLI installed and configured correctly.${NC}"
    fi
    
    cd ..
}

# Function to invoke the Lambda function
invoke_lambda() {
    echo -e "${BLUE}Invoking Lambda function...${NC}"
    cd terraform || { echo -e "${RED}Error: terraform directory not found${NC}"; return 1; }
    
    # Check if the Lambda function exists
    lambda_name=$(terraform output -raw lambda_function_name 2>/dev/null)
    
    if [ $? -ne 0 ] || [ -z "$lambda_name" ]; then
        echo -e "${YELLOW}Lambda function not deployed yet or output not available.${NC}"
        cd ..
        return 1
    fi
    
    echo -e "${GREEN}Lambda Function Name: $lambda_name${NC}"
    echo -e "${BLUE}Enter payload for Lambda function (press Enter for empty payload):${NC}"
    read -r payload
    
    if [ -z "$payload" ]; then
        payload="{}"
    fi
    
    echo -e "${BLUE}Invoking Lambda function...${NC}"
    
    # Create a temporary file for the response
    response_file=$(mktemp)
    
    # Use AWS CLI to invoke Lambda function
    aws lambda invoke --function-name "$lambda_name" --payload "$payload" "$response_file" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Lambda function invoked successfully!${NC}"
        echo -e "${BLUE}Response:${NC}"
        cat "$response_file"
    else
        echo -e "${RED}Error invoking Lambda function.${NC}"
        echo -e "${YELLOW}Make sure you have AWS CLI installed and configured correctly.${NC}"
    fi
    
    # Remove the temporary file
    rm -f "$response_file"
    
    cd ..
}

# Main menu
main_menu() {
    while true; do
        display_header
        echo -e "1. ${BLUE}Check AWS Credentials${NC}"
        echo -e "2. ${BLUE}Initialize Terraform${NC}"
        echo -e "3. ${BLUE}Validate Terraform Configuration${NC}"
        echo -e "4. ${BLUE}Plan Terraform Changes${NC}"
        echo -e "5. ${BLUE}Apply Terraform Changes${NC}"
        echo -e "6. ${BLUE}Destroy Terraform Resources${NC}"
        echo -e "7. ${BLUE}Show Terraform Outputs${NC}"
        echo -e "8. ${BLUE}Format Terraform Files${NC}"
        echo -e "9. ${BLUE}Workspace Management${NC}"
        echo -e "10. ${BLUE}Run TFLint${NC}"
        echo -e "11. ${BLUE}Show Lambda Function Details${NC}"
        echo -e "12. ${BLUE}Invoke Lambda Function${NC}"
        echo -e "0. ${RED}Exit${NC}"
        echo ""
        echo -e "Enter your choice: "
        read -r choice
        
        case $choice in
            1) check_aws_credentials; press_enter_to_continue ;;
            2) initialize_terraform; press_enter_to_continue ;;
            3) validate_terraform; press_enter_to_continue ;;
            4) plan_terraform; press_enter_to_continue ;;
            5) apply_terraform; press_enter_to_continue ;;
            6) destroy_terraform; press_enter_to_continue ;;
            7) show_outputs; press_enter_to_continue ;;
            8) format_terraform; press_enter_to_continue ;;
            9) workspace_menu; ;;
            10) run_tflint; press_enter_to_continue ;;
            11) show_lambda_details; press_enter_to_continue ;;
            12) invoke_lambda; press_enter_to_continue ;;
            0) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid choice. Please try again.${NC}"; press_enter_to_continue ;;
        esac
    done
}

# Workspace management menu
workspace_menu() {
    while true; do
        display_header
        echo -e "${BLUE}Workspace Management${NC}"
        echo ""
        echo -e "1. ${BLUE}Show Current Workspace${NC}"
        echo -e "2. ${BLUE}Create New Workspace${NC}"
        echo -e "3. ${BLUE}Select Workspace${NC}"
        echo -e "0. ${BLUE}Back to Main Menu${NC}"
        echo ""
        echo -e "Enter your choice: "
        read -r workspace_choice
        
        case $workspace_choice in
            1) show_workspace; press_enter_to_continue ;;
            2) create_workspace; press_enter_to_continue ;;
            3) select_workspace; press_enter_to_continue ;;
            0) return ;;
            *) echo -e "${RED}Invalid choice. Please try again.${NC}"; press_enter_to_continue ;;
        esac
    done
}

# Function to pause and wait for user input
press_enter_to_continue() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Start the main menu
main_menu
