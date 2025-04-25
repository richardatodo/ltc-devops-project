output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane (kubectl)"
  value       = module.eks.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  description = "OIDC Issuer URL for the EKS cluster (for IRSA)"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "configure_kubectl" {
  description = "Command to configure kubectl for this cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}