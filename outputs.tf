output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "EKS cluster CA data"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}


output "atlantis_external_ip" {
  description = "External IP address for Atlantis service"
  value       = data.kubernetes_service.atlantis_service.status[0].load_balancer[0].ingress[0].hostname
}



