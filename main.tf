terraform {
  backend "s3" {
    bucket  = "soat-terraform-state-5dc9264c8c230a834fe2a59b744523fd"
    key     = "kubernates/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
  map_public_ip_on_launch  = true
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.lab_role_arn
  version  = "1.32"

  vpc_config {
    subnet_ids = module.vpc.public_subnets
  }
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "academy-nodes"
  node_role_arn   = var.lab_role_arn
  subnet_ids      = module.vpc.public_subnets

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]
}
