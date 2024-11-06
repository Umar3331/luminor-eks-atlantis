module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-north-1a", "eu-north-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  #depends_on = [module.eks]

  tags = {
    "Name" = "eks-vpc"
  }
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.28.0"

  cluster_name    = "luminor-cluster"
  cluster_version = "1.31"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # Define EKS Managed Node Groups
  eks_managed_node_groups = {
    worker_group = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"

      labels = {
        Name = "luminor-worker"
      }

      tags = {
        "Name" = "luminor-worker"
      }
    }
  }

  # Enable cluster creator admin permissions
  enable_cluster_creator_admin_permissions = true

  # Define access entries for IAM roles
  access_entries = {
    eks_admin = {
      principal_arn     = aws_iam_role.eks_admin.arn
      kubernetes_groups = ["eks-admins"]
    },
    eks_read_only = {
      principal_arn     = aws_iam_role.eks_read_only.arn
      kubernetes_groups = ["eks-read-only"]
    }
  }

  tags = {
    "Name" = "luminor-cluster"
  }
}

# IAM Role for Admin User
resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

# IAM Role for Read-Only User
resource "aws_iam_role" "eks_read_only" {
  name = "eks-read-only"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

# Assume Role Policy Document
data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# Attach Policies to Roles
resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "eks_read_only_attach" {
  role       = aws_iam_role.eks_read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

