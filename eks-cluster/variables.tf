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
  default     = "1.31"
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  type        = string
  default     = "t3.medium" # Choose based on expected workload
}

variable "node_group_name" {
  description = "Name for the EKS managed node group"
  type        = string
  default     = "my-ltc-eks-nodegroup"
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