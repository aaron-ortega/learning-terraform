provider "aws" {
  # Provider gives access to resource(s)
  profile = "terraform"
  region = "us-east-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  # tf_course is the resource name according to terraform
  # resource name according to aws
  bucket = "tf-course-ortega-aaron"
  acl = "private"
}

resource "aws_default_vpc" "default" {}  # use default features