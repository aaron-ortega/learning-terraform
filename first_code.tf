provider "aws" {
  profile = "terraform"
  region = "us-east-2"
}

resource "aws_s3_bucket" "tf_course" {
  bucket = "tf-course-ortega-aaron"
  acl = private
}
