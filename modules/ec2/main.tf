data "aws_iam_instance_profile" "home_assignment_role" {
  name = "home-assignment-role-ec2"
}

resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]

  iam_instance_profile = data.aws_iam_instance_profile.home_assignment_role.name  
  tags = {
    Name = var.instance_name
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y python3-pip
    sudo pip3 install flask
    sudo pip3 install boto3
EOF
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.ec2_instance.id
  port             = 8080
}
