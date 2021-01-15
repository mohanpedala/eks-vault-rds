# Security group resources
resource "aws_security_group" "db_security_group" {
  vpc_id = var.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name        = "sgvaultdb",
      Project     = var.project,
      Environment = var.environment
    },
    var.tags
  )
}

