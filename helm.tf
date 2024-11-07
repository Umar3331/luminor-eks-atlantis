provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "helm_release" "atlantis" {
  name             = "atlantis"
  repository       = "https://runatlantis.github.io/helm-charts"
  chart            = "atlantis"
  namespace        = "atlantis"
  create_namespace = true

  values = [file("${path.module}/values.yaml")]

  set {
    name  = "orgAllowlist"
    value = "github.com/umar3331/luminor-eks-atlantis"
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "volumeClaim.dataStorage"
    value = "5Gi"
  }

  depends_on = [null_resource.install_ebs_csi_driver]
}

