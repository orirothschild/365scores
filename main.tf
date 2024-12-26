module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  ec2_rules = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = "ori-home-assignment.xyz"
  validation_method = "DNS"

  subject_alternative_names = [
    "www.ori-home-assignment.xyz"
  ]

  tags = {
    Name = "ori-home-assignment-certificate"
  }
}

resource "aws_route53_record" "certificate_validation" {
  for_each = { for v in aws_acm_certificate.certificate.domain_validation_options : v.resource_record_name => v }

  zone_id = data.aws_route53_zone.zone.id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

module "elb" {
  source            = "./modules/elb"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.security_groups.elb_sg_id
  certificate_arn   = aws_acm_certificate.certificate.arn

  target_group_health_check = {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

module "ec2" {
  source            = "./modules/ec2"
  ami_id            = "ami-02df5cb5ad97983ba" 
  instance_type     = "t3.micro"
  target_group_arn  = module.elb.target_group_arn  
  key_name          = "home-assignment-kp" 
  subnet_id         = module.vpc.public_subnets[0]
  security_group_id = module.security_groups.ec2_sg_id
  instance_name     = "EC2-Instance-Behind-ALB"
}


resource "aws_route53_record" "alb_a_record" {
  zone_id = "Z09615663VETF7OFGW69J"  
  name    = "ori-home-assignment.xyz" 
  type    = "A"
  alias {
    name                   = module.elb.elb_dns_name
    zone_id                = module.elb.zone_id
    evaluate_target_health = true
  }
}