variable "region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "luminor-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "desired_worker_count" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 1
}

variable "max_worker_count" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 2
}

variable "github_user" {
  description = "GitHub username for Atlantis"
}

variable "github_token" {
  description = "GitHub token for Atlantis"
  sensitive   = true
}

variable "github_secret" {
  description = "GitHub webhook secret for Atlantis"
  sensitive   = true
}

variable "org_allowlist" {
  description = "Repository allowlist for Atlantis"
}
<<<<<<< HEAD

=======
>>>>>>> e3ad72a (test)
