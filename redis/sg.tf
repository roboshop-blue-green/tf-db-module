resource "aws_security_group" "allow-redis" {
  name        = "redis-${var.ENV}-sg"
  description = "redis-${var.ENV}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "REDIS"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "redis-${var.ENV}-sg"
  }
}