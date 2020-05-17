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

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-2a"
    tags = {
      "Terraform" : "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-east-2b"
    tags = {
      "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  # "prod_web" name can be reused since it's
  # diffentiate by resource type (no name collision)
  count = 2

  ami = "ami-0d9ef3d936a8fa1c6"
  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_eip_association" "prod_web" {
  instance_id   = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform" : "true"
  }
}

resource "aws_elb" "prod_web" {
  name            = "prod-web"
  instances       = aws_instance.prod_web.*.id
  subnets         = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
  tags = {
    "Terraform" : "true"
  }
}