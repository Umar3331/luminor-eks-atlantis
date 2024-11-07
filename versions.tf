# Terraform block specifying the required Terraform version and providers
terraform {
  required_version = ">= 1.3.2"
  
  # Specify required providers with their sources and minimum versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}
