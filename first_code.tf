provider "aws" {
  # Provider gives access to resource(s)
  profile = "terraform-user"
  region = "us-east-2"
}

// How to make a resource?
// Choose a resource and then provide a name that terraform will use to identify it
resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-course-20200213-ortega"  # globally unique
  acl    = "private"
}