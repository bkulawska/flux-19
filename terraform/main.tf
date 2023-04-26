terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
    profile = "default"
    region = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "${var.proj_name}-${random_string.suffix.result}"
}

# lab account already creates vpc with gateway and proper routing for us
data "aws_vpc" "selected_vpc" {
}

data "aws_subnets" "vpc_subnets" {
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.selected_vpc.id]
    }

    filter {
      name = "availability-zone"
      values = [for zone_id in var.node_azs: "${var.region}${zone_id}"]
    }
}

resource "aws_eks_cluster" "cluster" {
  name     = local.cluster_name
  role_arn = var.lab_role_arn

  vpc_config {
    subnet_ids = data.aws_subnets.vpc_subnets.ids
  }
}

resource "aws_eks_addon" "vpc_cni_addon" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "kube_proxy_addon" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"
}

resource "aws_eks_addon" "coredns_addon" {
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "coredns"
  resolve_conflicts = "OVERWRITE"
  depends_on = [
    aws_eks_node_group.cluster_node_group
  ]
}

resource "aws_eks_node_group" "cluster_node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${local.cluster_name}-ng"
  node_role_arn   = var.lab_role_arn

  subnet_ids = data.aws_subnets.vpc_subnets.ids

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_eks_addon.vpc_cni_addon,
    aws_eks_addon.kube_proxy_addon
  ]
}

