resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster_name}"
  }

  depends_on = [module.eks]
}

resource "null_resource" "install_ebs_csi_driver" {
  provisioner "local-exec" {
    command = "kubectl apply -k https://github.com/Umar3331/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr?ref=master --validate=false"
  }

  # This ensures that kubeconfig is updated before installing the CSI driver
  depends_on = [null_resource.update_kubeconfig]
}

