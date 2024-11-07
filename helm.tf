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

  values = [
    <<EOF
    orgAllowlist: "${var.org_allowlist}"
    github:
      user: "${var.github_user}"
      token: "${var.github_token}"
      secret: "${var.github_secret}"
    service:
      type: LoadBalancer
    volumeClaim:
      enabled: true
      dataStorage: 5Gi
      storageClassName: "gp2"
      accessModes:
        - ReadWriteOnce
    EOF
  ]

  depends_on = [null_resource.install_ebs_csi_driver]
}

