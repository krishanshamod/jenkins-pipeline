# Private ecr repository
resource "aws_ecr_repository" "ecr" {
  name                 = "jenkins-pipeline-ecr"
  image_tag_mutability = "IMMUTABLE"
}