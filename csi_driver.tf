
# Resource to update the kubeconfig file for accessing the EKS cluster
resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }

  depends_on = [module.eks]
}

# Resource to install the EBS CSI driver in the Kubernetes cluster
resource "null_resource" "install_ebs_csi_driver" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/Umar3331/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr?ref=master --validate=false"
  }

  # This ensures that kubeconfig is updated before installing the CSI driver
  depends_on = [null_resource.update_kubeconfig]
}

