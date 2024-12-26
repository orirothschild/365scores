📂 Project Structure
python
Copy code
365scores/
├── app
│   ├── app.py               # Flask app serving web content
│   └── scriptapp.py         # Supporting scripts
├── backend.tf               # Backend configuration (e.g., remote state)
├── data.tf                  # Data sources (e.g., Route 53 zones)
├── main.tf                  # Main Terraform configuration
├── modules
│   ├── ec2                 # EC2 module
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── elb                 # ALB module
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── security_groups     # Security Groups module
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   └── vpc                 # VPC module
│       ├── data.tf
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── my_archive.zip           # Archived app files
├── output.tf                # Outputs for infrastructure resources
├── providers.tf             # Providers (e.g., AWS)
└── variables.tf             # Global variables


🌐 Architecture Overview
This architecture creates a fully functional web hosting environment on AWS:

VPC Module

Public and Private Subnets: Isolated environments for resources.
Routing Rules: Includes an Internet Gateway (IGW) for public resources and NAT Gateway for private subnets.
Security Groups Module

Configures rules to secure EC2 instances, ALB, and other resources.
Allows inbound traffic on HTTP, HTTPS, and SSH ports.
ACM Certificate

Ensures secure HTTPS communication for the domain (ori-home-assignment.xyz).
ALB Module

Configures an Application Load Balancer with target groups and health checks.
Routes traffic to EC2 instances running the application.
EC2 Module

Deploys a t3.micro instance with the Flask application.
The instance is registered with the ALB's target group.
Route 53 DNS

Sets up a domain (ori-home-assignment.xyz) pointing to the ALB.
Configures alias records for seamless traffic routing.
🔧 How It Works

VPC Setup:

Public and private subnets are created along with routing and an Internet Gateway.
Security Groups:

Security groups ensure EC2 and ALB can handle traffic securely.
Load Balancing with ALB:

The ALB listens for HTTP/HTTPS requests and forwards them to the EC2 target group.
Health checks are configured to monitor the application.
EC2 Deployment:

A Flask app (app.py) is deployed on the EC2 instance.
The instance serves content through the ALB.
Route 53 and ACM:

DNS records are created to point to the ALB.
ACM certificates ensure the application is served over HTTPS.