variable "name_servers" {
  type = "list"
}

resource "aws_route53_record" "ns" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "scf.engineerbetter.com"
  type    = "NS"
  ttl     = "300"
  records = ${var.name_servers}
}
