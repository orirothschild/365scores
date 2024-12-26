output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC ID that was created"
}

output "security_group_id" {
  value       = module.security_groups.elb_sg_id
  description = "The ID of the security group created for ELB"
}

output "domain_name" {
  value       = aws_acm_certificate.certificate.domain_name
  description = "The domain name associated with the certificate"
}

output "certificate_arn" {
  value       = aws_acm_certificate.certificate.arn
  description = "The ARN of the ACM certificate"
}

output "alb_url" {
  value       = module.elb.elb_dns_name
  description = "The DNS name of the ALB (Application Load Balancer)"
}
