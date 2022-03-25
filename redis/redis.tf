resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-${var.ENV}"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.subnet-group.name
  security_group_ids   = [aws_security_group.allow-redis.id]
}

resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "redis-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNETS_IDS
}

output "redis" {
  value = aws_elasticache_cluster.redis
}