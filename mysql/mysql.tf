resource "aws_db_instance" "default" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  db_name                = "dummy"
  username               = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_USER"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_PASS"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.mysql.name
  vpc_security_group_ids = [aws_security_group.allow-mysql.id]
}

resource "aws_db_subnet_group" "mysql" {
  name       = "mysql"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS

  tags = {
    Name = "MySQL DB Subnet Group"
  }
}

resource "null_resource" "schema" {
  provisioner "local-exec" {
    command = <<EOF
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-blue-green/mysql/archive/main.zip"
cd /tmp
unzip -o /tmp/mysql.zip
cd mysql-main
mysql -h ${aws_db_instance.default.address} -u${jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_USER"]} -p${jsondecode(data.aws_secretsmanager_secret_version.latest.secret_string)["RDS_PASS"]} < shipping.sql
EOF
  }
}