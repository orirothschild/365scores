variable "vpc_id" {}
variable "public_subnets" {}
variable "security_group_id" {}
variable "certificate_arn" {
  default = null
}
variable "target_group_health_check" {
  default = {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}
