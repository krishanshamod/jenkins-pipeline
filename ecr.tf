# Private ecr repository
resource "aws_ecr_repository" "ecr" {
  name                 = "jenkins-pipeline-ecr"
  image_tag_mutability = "MUTABLE"
}

# IAM role for EC2 with ECR access
resource "aws_iam_role" "ecr_role" {
  name                = "ECRFullAccessEC2"
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Instance profile for EC2
resource "aws_iam_instance_profile" "ecr_ec2_profile" {
  name = "ecr_ec2_profile"
  role = aws_iam_role.ecr_role.name
}