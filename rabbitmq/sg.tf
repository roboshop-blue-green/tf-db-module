resource "aws_security_group" "allow-rabbitmq" {
  name        = "rabbitmq-${var.ENV}-sg"
  description = "rabbitmq-${var.ENV}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR, data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]
  }

  ingress {
    description = "HTTP"
    from_port   = 5672
    to_port     = 5672
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
    Name = "rabbitmq-${var.ENV}-sg"
  }
}