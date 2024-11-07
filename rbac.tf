resource "kubernetes_cluster_role_binding" "eks_admin_binding" {
  metadata {
    name = "eks-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "eks-admins"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "eks_read_only" {
  metadata {
    name = "eks-read-only-role"
  }
  rule {
    api_groups = [""]
    resources  = ["nodes", "pods", "services", "endpoints", "persistentvolumeclaims", "persistentvolumes", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
  # Add additional rules as per requirement
}

resource "kubernetes_cluster_role_binding" "eks_read_only_binding" {
  metadata {
    name = "eks-read-only"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.eks_read_only.metadata[0].name
  }
  subject {
    kind      = "Group"
    name      = "eks-read-only"
    api_group = "rbac.authorization.k8s.io"
  }
}

