locals {
  admin_user    = "admin"
  admin_group   = "admins"
  admin_policy   = "admins"
}

# --- users ---
resource "aws_iam_user" "admin" {
  name = "${local.admin_user}"
}

resource "aws_iam_user_login_profile" "admin" {
  user    = "${aws_iam_user.admin.name}"
  pgp_key = "${var.admin-public-key}"
  password_length = 12
  #password_reset_required = "true"
}

# --- groups ---
resource "aws_iam_group" "admins" {
  name = "${var.project}-${local.admin_group}"
}

# --- users <-> groups ---
resource "aws_iam_user_group_membership" "admin" {
  user    = "${aws_iam_user.admin.name}"
  groups = [
    "${aws_iam_group.admins.name}",
  ]
}

# --- policies ---

resource "aws_iam_policy" "admins" {
  name        = "${var.project}-${local.admin_policy}"
  description = "maintainers policy allowing buckets rw and logging"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Effect": "Allow",
            "Action": [
                "cloudformation:DescribeChangeSet",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStacks",
                "cloudformation:GetTemplate",
                "cloudformation:ListStackResources",
                "cloudwatch:*",
                "cognito-identity:ListIdentityPools",
                "cognito-sync:GetCognitoEvents",
                "cognito-sync:SetCognitoEvents",
                "dynamodb:*",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "events:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:ListAttachedRolePolicies",
                "iam:ListRolePolicies",
                "iam:ListRoles",
                "iam:PassRole",
                "iot:AttachPrincipalPolicy",
                "iot:AttachThingPrincipal",
                "iot:CreateKeysAndCertificate",
                "iot:CreatePolicy",
                "iot:CreateThing",
                "iot:CreateTopicRule",
                "iot:DescribeEndpoint",
                "iot:GetTopicRule",
                "iot:ListPolicies",
                "iot:ListThings",
                "iot:ListTopicRules",
                "iot:ReplaceTopicRule",
                "kinesis:DescribeStream",
                "kinesis:ListStreams",
                "kinesis:PutRecord",
                "kms:ListAliases",
                "lambda:*",
                "logs:*",
                "s3:*",
                "sns:ListSubscriptions",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sns:Publish",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "sqs:ListQueues",
                "sqs:SendMessage",
                "tag:GetResources",
                "xray:PutTelemetryRecords",
                "xray:PutTraceSegments"
            ],
            "Resource": "*"
        }
    , {
            "Effect": "Allow",
            "Action": [
                "iam:*",
                "organizations:DescribeAccount",
                "organizations:DescribeOrganization",
                "organizations:DescribeOrganizationalUnit",
                "organizations:DescribePolicy",
                "organizations:ListChildren",
                "organizations:ListParents",
                "organizations:ListPoliciesForTarget",
                "organizations:ListRoots",
                "organizations:ListPolicies",
                "organizations:ListTargetsForPolicy"
            ],
            "Resource": "*"
        }
    , {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "*"
        }
    ,  {
            "Action": [
                "autoscaling:Describe*",
                "cloudwatch:*",
                "logs:*",
                "sns:*",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        }
    , {
            "Action": [
                "dynamodb:*",
                "dax:*",
                "application-autoscaling:DeleteScalingPolicy",
                "application-autoscaling:DeregisterScalableTarget",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingActivities",
                "application-autoscaling:DescribeScalingPolicies",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:RegisterScalableTarget",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:PutMetricAlarm",
                "datapipeline:ActivatePipeline",
                "datapipeline:CreatePipeline",
                "datapipeline:DeletePipeline",
                "datapipeline:DescribeObjects",
                "datapipeline:DescribePipelines",
                "datapipeline:GetPipelineDefinition",
                "datapipeline:ListPipelines",
                "datapipeline:PutPipelineDefinition",
                "datapipeline:QueryObjects",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:ListSubscriptions",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "sns:SetTopicAttributes",
                "lambda:CreateFunction",
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:CreateEventSourceMapping",
                "lambda:DeleteEventSourceMapping",
                "lambda:GetFunctionConfiguration",
                "lambda:DeleteFunction",
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources",
                "resource-groups:GetGroup",
                "resource-groups:GetGroupQuery",
                "resource-groups:DeleteGroup",
                "resource-groups:CreateGroup",
                "tag:GetResources"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": [
                        "application-autoscaling.amazonaws.com",
                        "dax.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "replication.dynamodb.amazonaws.com",
                        "dax.amazonaws.com",
                        "dynamodb.application-autoscaling.amazonaws.com"
                    ]
                }
            }
        }
  ]
}
EOF
}


# --- policies <-> groups ---
resource "aws_iam_group_policy_attachment" "admins" {
  group      = "${aws_iam_group.admins.name}"
  policy_arn = "${aws_iam_policy.admins.arn}"
}

















