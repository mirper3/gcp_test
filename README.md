# gcp_test
Prerequisites
Before you begin, ensure you have the following prerequisites installed on your local machine:

Terraform: Make sure you have Terraform installed. You can check the installation by running terraform --version.

Cloud Provider Account: You'll need an account with the GCP project you intend to use. Ensure that you have the necessary API credentials and access permissions configured, like SSH keys, credentials.json, etc...

Git: You should have Git installed on your local machine to clone the repository. You can download it here.

Getting Started
Follow these steps to set up and use the Terraform scripts:

Clone the Repository:

git clone https://github.com/mirper3/gcp_test
cd gcp_test

Initialize Terraform:

Run the following command to initialize Terraform with the required providers:

terraform init

Set Variables:

Customize the Terraform variables to match your infrastructure requirements. You can do this by editing the variables.tf file.

Plan:

Generate a Terraform execution plan to see what resources will be created, modified, or destroyed:

terraform plan

Apply:

Apply the Terraform configuration to create or update resources based on your configuration:

terraform apply

You will be prompted to confirm the action. Type yes to proceed.

Destroy (Optional):

To destroy the infrastructure when you are done, use:

terraform destroy
