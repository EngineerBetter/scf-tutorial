variable "name_servers" {
  type = "list"
}

data "aws_route53_zone" "parent_zone" {
  name = "engineerbetter.com."
}

resource "aws_route53_record" "ns" {
  zone_id = "${data.aws_route53_zone.parent_zone.zone_id}"
  name    = "scf.engineerbetter.com"
  type    = "NS"
  ttl     = "300"
  records = "${var.name_servers}"
}
