module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets # Deploy control plane to private subnets

  # EKS Managed Node Group(s) configuration
  eks_managed_node_group_defaults = {
    # Use the default IAM role created by the module
    # Role allows nodes to communicate with the cluster control plane
    iam_role_attach_cni_policy = true # Attach the Amazon VPC CNI policy
  }

  eks_managed_node_groups = {
    # Define one node group (can define multiple)
    (var.node_group_name) = {
      name           = var.node_group_name
      instance_types = [var.node_instance_type]

      min_size     = var.node_group_min_size
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size

      # Use private subnets for worker nodes for better security
      subnet_ids = module.vpc.private_subnets

      # Add common tags
      tags = var.tags
    }
  }

  enable_irsa = true # Enable IAM Roles for Service Accounts

  tags = var.tags
}