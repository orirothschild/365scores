data "aws_acm_certificate" "certificate" {
  domain   = "ori-home-assignment.xyz"
  most_recent = true
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "zone" {
  name = "ori-home-assignment.xyz."
}