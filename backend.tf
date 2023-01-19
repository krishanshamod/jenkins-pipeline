# Terraform backend configuration
terraform {
  backend "s3" {
    bucket         = "terraform-state-insighture-new-project"
    key            = "jenkins-pipeline-infrastructure/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}