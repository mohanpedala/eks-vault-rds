resource "aws_eks_cluster" "aws_eks" {
  name     = "eks_cluster_vault"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = var.aws_subnet_group
  }

  tags = merge(
    {
      Name        = "eksvault",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

## node group
resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.aws_eks.name
  node_group_name = "node_vault"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = ["subnet-83bae0f5", "subnet-7031925b"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = merge(
    {
      Name        = "eksnodegroupvault",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}