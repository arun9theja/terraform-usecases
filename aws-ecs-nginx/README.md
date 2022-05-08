# Hi, I'm Murali! 👋

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

# AWS Requirements
 - Should have an active AWS account. Create a free tier if you don't have one.
 - Create an IAM user for the terraform with Programmatic access (refer the link https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html to create an IAM user) and download that user's Access key and Secret access key to your local.
 - Make sure you generate a key pair in the AWS console (.pem format for ssh and .ppk format for windows putty) and keep it handy at your local machine (where you run your terraform scripts) for ssh or putty connections to EC2 instances.
 - In the file ec2.tf under modules/ec2/ folder you can find in the code under provisioner/connection, the path specified for terraform.pem file but the file is not included here in the github repo since you need to provide the key file from your AWS account. So please copy your key file that you generated in the previous step to the path modules/ec2/ for your local machine to connect with the terraform created EC2 instances.
 
# Steps to Authenticate with AWS

- Step 1:  Install AWS CLI on your local machine where you are going to run terraform (refer the link https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) and configure your AWS account by running "aws config" command in your terminal. Verify if your aws cli is installed correctly and able to connect to your account with some basic aws cli command.
- Step 2:  If you don't want to install AWS CLI, you should hardcode the values of your AWS Access and Secret Access keys inside the providers.tf file.(But that is not a recommended approach)
- Step 3:  Clone this repository to your local using git clone <url> command.

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
For support, email support@cloudnloud.com or join our Discord channel.


