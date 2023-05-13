output "cluster_name" {
    value = aws_eks_cluster.cluster.name
}

output "region" {
    value = var.region
}

output "lab_role_arn" {
    value = data.aws_iam_role.lab_role.arn
}
