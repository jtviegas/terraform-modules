# --- roles ---
resource "aws_iam_role" "bucket-event-handling-role" {
  name = "${var.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": { "AWS": "arn:aws:iam::692391178777:root" },
    "Action": "sts:AssumeRole"
  }
  ,
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
  ]
}
EOF
}

# --- policies ---
resource "aws_iam_policy" "bucket-event-handling-role-function-policy" {
  name        = "${var.name}-policy"
  description = "policy for the buckets event function allowing logging, buckets rw and rw on the dynamodb tables"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${var.bucket-id}","arn:aws:s3:::${var.bucket-id}/*"],
      "Action": "s3:*"
    }
    , {
      "Effect": "Allow",
      "Resource": "arn:aws:logs:*:*:*",
      "Action": "logs:*"
    }
    , {
      "Effect": "Allow",
      "Resource": "arn:aws:dynamodb:*:*:table/*",
      "Action": "dynamodb:*"
    }
  ]
}
EOF
}


# --- policies <-> roles ---
resource "aws_iam_role_policy_attachment" "entity-event-function-role-policy" {
  role       = "${aws_iam_role.bucket-event-handling-role.name}"
  policy_arn = "${aws_iam_policy.bucket-event-handling-role-function-policy.arn}"
}


















