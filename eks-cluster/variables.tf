variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # Change to your desired region
}

variable "cluster_name" {
  description = "Name for the EKS cluster"
  type        = string
  default     = "ltc-eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31" # Check AWS EKS documentation for latest supported versions
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"] # across 3 AZs
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"] # across 3 AZs
}

variable "azs" {
  description = "Availability Zones for VPC subnets"
  type        = list(string)
  # If default region is changed, update AZs accordingly
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium" # Choose based on expected workload
}

variable "node_group_name" {
  description = "Name for the EKS managed node group"
  type        = string
  default     = "ltc-eks-nodegroup"
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "LTC-DevOps"
    Environment = "Development"
    ManagedBy   = "Terraform"
  }
}