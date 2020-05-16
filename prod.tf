provider "aws" {
  # Provider gives access to resource(s)
  profile = "terraform"
  region = "us-east-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  # prod_tf_course is the resource name according to terraform
  # while bucket is the resource according to aws
  bucket = "tf-course-ortega-aaron"
  acl = "private"
}

resource "aws_default_vpc" "default" {}  # use default features

resource "aws_security_group" "prod_web" {
  name        = "prod_web"  # aws name
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]  # everything
  }
  ingress {
    from_port = 443
    protocol  = "tcp"
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    # Tag to identify which resource is managed by terraform
    "Terraform" : "true"
  }
}
