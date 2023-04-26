output "cluster_name" {
    value = aws_eks_cluster.cluster.name
}

output "region" {
    value = var.region
}