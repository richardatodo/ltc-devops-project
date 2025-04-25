module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"# Use a compatible VPC module version

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true # Required for nodes in private subnets to reach internet (e.g., ECR)
  single_nat_gateway = true # Use a single NAT gateway for cost savings in dev/test
  enable_dns_hostnames = true

  # Tags required by EKS
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                  = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"         = "1"
  }

  tags = var.tags
}