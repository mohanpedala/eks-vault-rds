terraform {
  backend "s3" {
    bucket = "prod-terraform-state-backend"
    key    = "eks-vault-rds"
    region = "us-west-2"
  }
}