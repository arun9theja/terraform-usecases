# Terraform AWS Web Deployment Automation

# Before starting this exercise, make sure Terraform is installed in your machine.

# Ubuntu

    $ wget https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
    $ unzip terraform_0.13.5_linux_amd64.zip
    $ sudo mv terraform /usr/local/bin

# Windows 10 or 8 or 7
    1. Download Terraform
    2. Unzip the terraform package
    3. Configure environment variables for terraform
    4. Verify installation with terraform version or terraform -help commands

# Mac OS
    $ brew tap hashicorp/tap    
    $ brew install hashicorp/tap/terraform
    $ terraform -help

# AWS
 - Should have an active AWS account. Create a free tier if you don't have one.
 - Create an IAM user for the terraform and download the access key and secret access key to your local.
 - make sure you generate a key pair in the AWS console and keep it handy at your local for ssh connections to EC2 instances,
 
# Steps

- Step 1:  Install AWS CLI on the local machine and configure the AWS account using aws config command.
- Step 2:  If you don't want to install AWS CLI, you should hardcode the values of access and secret access keys in providers.tf file.
- Step 3:  Clone this repository to your local using git clone <url> command.

# commands

    1. terraform version
    2. terraform fmt
    3. terraform init
    4. terraform plan
    5. terraform apply
    6. terraform destroy