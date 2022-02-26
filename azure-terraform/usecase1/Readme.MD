
# Pre-requisites

Follow the below steps to install Terraform in your preferred OS

## Ubuntu

    $ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
    $ unzip terraform_0.13.5_linux_amd64.zip
    $ sudo mv terraform /usr/local/bin

## Windows 10 or 8 or 7
    1. Download Terraform
    2. Unzip the terraform package
    3. Configure environment variables for terraform
    4. Verify installation with terraform version or terraform -help command

## Mac OS
    $ brew tap hashicorp/tap    
    $ brew install hashicorp/tap/terraform
    $ terraform -help

# AZURE Requirements
 - Should have an active Azure account with subscription. Create a free tier if you don't have one.
 - To be able to connect with the created vm using ssh, make sure you have the public key generated and placed in the path "~/.ssh/id_rsa.pub"
 
# Steps to Authenticate with Azure

- Step 1:  Install Azure CLI on your local machine where you are going to run terraform (refer the link https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and configure your AWS account by running "az login" command in your terminal authenticate the account in the browser that would open automatically. Verify if your Azure CLI is installed correctly by running "az account list" command.
- Step 2:  Clone this repository to your local using git clone <url> command.
- Step 3:  Copy your account Subscription ID and provide it in the provider block in provider.tf file.

# Terraform commands to execute

    1. terraform version
    2. terraform fmt
    3. terraform init
    4. terraform plan
    5. terraform apply
    6. terraform destroy
    

## 🚀 About Me
I'm a Senior DevOps Engineer and a Cloud Consultant...


## Support
For support, email support@cloudnloud.com or join our Slack channel.

