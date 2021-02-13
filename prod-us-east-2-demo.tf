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
  bucket = "tf-course-20200213-ortega"  # globally unique
  acl    = "private"
}

resource "aws_default_vpc" "default" {}

