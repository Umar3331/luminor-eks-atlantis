module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.15.0"

  name                 = "${var.cluster_name}-vpc"
  cidr                 = var.vpc_cidr
  azs                  = ["${var.region}a", "${var.region}b"]
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "${var.cluster_name}-vpc"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.28.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    iam_role_additional_policies = {
      AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
    }
  }

  eks_managed_node_groups = {
    worker_group = {
      desired_size   = var.desired_worker_count
      min_size       = var.desired_worker_count
      max_size       = var.max_worker_count
      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"

      labels = {
        Name = "${var.cluster_name}-worker"
      }

      tags = {
        "Name" = "${var.cluster_name}-worker"
      }
    }
  }

  enable_cluster_creator_admin_permissions = true

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
    "Name" = var.cluster_name
  }
}

resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

resource "aws_iam_role" "eks_read_only" {
  name = "eks-read-only"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json
}

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

resource "aws_iam_role_policy_attachment" "eks_admin_attach" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "eks_read_only_attach" {
  role       = aws_iam_role.eks_read_only.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "kubernetes_service" "atlantis_service" {
  metadata {
    name      = helm_release.atlantis.metadata[0].name
    namespace = "atlantis"
  }
}


