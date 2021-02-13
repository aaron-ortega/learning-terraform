/*
Notes:
  - Name convention for tf files: component-env-region-additional_descriptors (eg. networking-prod-us-west-other)
*/

provider "aws" {
  //  Provider gives access to resource(s)
  profile = "terraform-user"
  region  = "us-east-2"
}

/*
How to make a resource?
  1. Choose a resource type (eg an S3 bucket)
  2. Name the resource (used by terraform to uniquely identify it)
  3. Pass arguments to resource
*/
resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-20200213-ortega" # globally unique
  acl    = "private"
}

// No arguments passed; use default values
resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"  # name that AWS will use if empty a random name will be assigned
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] # list of IP address that this rule will apply to
  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1" # allow all
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
  }
}

resource "aws_instance" "prod_web" {
  # "prod_web" name can be reused since it's
  # differentiate by resource type (no name collision)
  ami           = "ami-04ed88a1d80127c62"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" : "true"
  }
}

// Add static IP (we can keep the IP address even if we destroy the image)
resource "aws_eip" "prod_web" {
  instance = aws_instance.prod_web.id

  tags = {
    "Terraform" : "true"
  }
}