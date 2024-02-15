## NOTE:
- BEST PRACTICE IS TO USE S3/DynamoDB FOR TEAM COLLABORATION

# Design
- 1 VPC
- 1 Internet Gateway
- 2 Subnet
- 2 Routing Table
- 1 Application Load Balancer
- 1 Target Group
- 2 Security Groups (1 LB, 1 EC2)
- 2 Linux AMI EC2 Instances
  - Includes .sh userdata to install apache/httpd webserver

# Terraform Simple Design
![Cloud Diagram SVG drawio](https://github.com/KevinNguyen091995/terraform/assets/83796419/2470305b-5de0-463f-8d37-7f042f993fa0)
