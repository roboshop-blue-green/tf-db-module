resource "aws_route53_record" "redis" {
  zone_id = data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONEID
  name    = "redis-${var.ENV}.${data.terraform_remote_state.vpc.outputs.INTERNAL_HOSTED_ZONE_NAME}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_elasticache_cluster.redis.cache_nodes[0].address]
}
