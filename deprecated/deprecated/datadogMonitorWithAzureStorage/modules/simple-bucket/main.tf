resource "aws_s3_bucket" "simple-bucket" {
  bucket = "${var.name}"
  acl    = "public-read"

  force_destroy = true

}
