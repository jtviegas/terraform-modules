terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# --- groups ---
resource "aws_iam_group" "admin" {
  name = var.group_name
}

# --- roles ---
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "admin_role" {
  name                = "aws_iam_role_${var.group_name}"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

# --- policies ---

resource "aws_iam_policy" "admin_group_main" {
  name        = "aws_iam_policy_group_main_${var.group_name}"
  description = "maintainers policy allowing buckets rw and logging"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/events.amazonaws.com/AWSServiceRoleForCloudWatchEvents*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "events.amazonaws.com"
                }
            }
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "iam:PassRole",
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
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
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
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "cloudwatch:DeleteAlarms",
                "cloudfront:ListFieldLevelEncryptionConfigs",
                "route53:TestDNSAnswer",
                "lambda:GetFunctionConfiguration",
                "xray:PutTraceSegments",
                "datapipeline:CreatePipeline",
                "cloudfront:GetStreamingDistribution",
                "sns:Subscribe",
                "lambda:DeleteFunction",
                "route53:GetHostedZoneCount",
                "iam:ListRolePolicies",
                "cloudformation:DescribeChangeSet",
                "cloudfront:GetDistributionConfig",
                "cloudformation:ListStackResources",
                "cloudfront:GetFieldLevelEncryptionConfig",
                "sns:*",
                "iam:GetRole",
                "cloudfront:GetCloudFrontOriginAccessIdentityConfig",
                "sns:ListSubscriptionsByTopic",
                "datapipeline:ListPipelines",
                "iam:GetPolicy",
                "lambda:ListFunctions",
                "cloudfront:GetPublicKey",
                "sns:CreateTopic",
                "sqs:SendMessage",
                "cloudwatch:GetMetricStatistics",
                "resource-groups:CreateGroup",
                "cloudwatch:*",
                "cloudfront:ListInvalidations",
                "cloudwatch:DescribeAlarms",
                "resource-groups:ListGroupResources",
                "lambda:DeleteEventSourceMapping",
                "datapipeline:ActivatePipeline",
                "iam:GetRolePolicy",
                "cloudfront:ListDistributionsByWebACLId",
                "cloudfront:ListCloudFrontOriginAccessIdentities",
                "xray:PutTelemetryRecords",
                "tag:GetResources",
                "cloudfront:DeleteCloudFrontOriginAccessIdentity",
                "cognito-identity:ListIdentityPools",
                "sns:ListTopics",
                "datapipeline:DescribePipelines",
                "cloudwatch:ListMetrics",
                "organizations:DescribePolicy",
                "cloudfront:CreateCloudFrontOriginAccessIdentity",
                "iam:PassRole",
                "cloudwatch:DescribeAlarmHistory",
                "cloudfront:UpdateDistribution",
                "cloudfront:UpdateCloudFrontOriginAccessIdentity",
                "cloudfront:UntagResource",
                "cloudfront:GetStreamingDistributionConfig",
                "s3:*",
                "route53:ListHostedZones",
                "datapipeline:QueryObjects",
                "iam:ListRoles",
                "sns:ListSubscriptions",
                "organizations:ListPolicies",
                "resource-groups:DeleteGroup",
                "kms:ListAliases",
                "organizations:ListParents",
                "cloudfront:ListStreamingDistributions",
                "cloudfront:DeleteDistribution",
                "acm:*",
                "iam:GetPolicyVersion",
                "organizations:ListRoots",
                "logs:*",
                "sns:Unsubscribe",
                "dynamodb:*",
                "organizations:DescribeAccount",
                "organizations:ListChildren",
                "cloudfront:GetDistribution",
                "cognito-sync:SetCognitoEvents",
                "organizations:DescribeOrganization",
                "resource-groups:GetGroup",
                "acm:RequestCertificate",
                "iam:ListAttachedRolePolicies",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudfront:GetFieldLevelEncryption",
                "cloudfront:GetFieldLevelEncryptionProfile",
                "route53:CreateHostedZone",
                "dax:*",
                "cloudfront:TagResource",
                "cloudformation:DescribeStackResources",
                "acm:ListTagsForCertificate",
                "cloudformation:DescribeStacks",
                "cloudfront:ListTagsForResource",
                "cloudformation:GetTemplate",
                "lambda:ListEventSourceMappings",
                "cloudfront:GetFieldLevelEncryptionProfileConfig",
                "resource-groups:GetGroupQuery",
                "sns:DeleteTopic",
                "cloudfront:GetPublicKeyConfig",
                "sns:SetTopicAttributes",
                "lambda:CreateEventSourceMapping",
                "sns:Publish",
                "cognito-sync:GetCognitoEvents",
                "organizations:DescribeOrganizationalUnit",
                "cloudfront:GetCloudFrontOriginAccessIdentity",
                "acm:ListCertificates",
                "organizations:ListPoliciesForTarget",
                "sqs:ListQueues",
                "datapipeline:PutPipelineDefinition",
                "organizations:ListTargetsForPolicy",
                "cloudfront:GetInvalidation",
                "datapipeline:DescribeObjects",
                "cloudfront:CreateDistribution",
                "resource-groups:ListGroups",
                "datapipeline:GetPipelineDefinition",
                "cloudwatch:PutMetricAlarm",
                "cloudfront:ListPublicKeys",
                "lambda:*",
                "cloudfront:ListFieldLevelEncryptionProfiles",
                "cloudfront:ListDistributions",
                "datapipeline:DeletePipeline"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "admin_group_route53" {
  name        = "aws_iam_policy_group_route53_${var.group_name}"
  description = "maintainers policy allowing route53 operations"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [

        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "route53:ListTagsForResources",
                "route53:GetQueryLoggingConfig",
                "route53:GetChange",
                "route53:GetHostedZone",
                "route53:ChangeResourceRecordSets",
                "route53:ChangeTagsForResource",
                "route53:ListResourceRecordSets",
                "route53:DeleteHostedZone",
                "route53:GetHostedZoneLimit",
                "route53:ListTagsForResource",
                "route53:ListQueryLoggingConfigs"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*",
                "arn:aws:route53:::trafficpolicyinstance/*",
                "arn:aws:route53:::healthcheck/*",
                "arn:aws:route53:::change/*",
                "arn:aws:route53:::trafficpolicy/*",
                "arn:aws:route53:::queryloggingconfig/*",
                "arn:aws:route53:::delegationset/*"
            ]
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": "route53:GetChange",
            "Resource": "arn:aws:route53:::change/*"
        },
        {
            "Sid": "VisualEditor6",
            "Effect": "Allow",
            "Action": [
                "route53:DeleteTrafficPolicy",
                "route53:ListTrafficPolicyVersions",
                "route53:GetHostedZone",
                "route53:GetHealthCheck",
                "route53:CreateQueryLoggingConfig",
                "route53:DeleteHealthCheck",
                "route53:ListResourceRecordSets",
                "route53:GetTrafficPolicyInstance",
                "route53:DeleteHostedZone",
                "route53:UpdateHostedZoneComment",
                "route53:DeleteTrafficPolicyInstance",
                "route53:CreateTrafficPolicyVersion",
                "route53:UpdateTrafficPolicyComment",
                "route53:UpdateTrafficPolicyInstance",
                "route53:ListTrafficPolicyInstancesByHostedZone",
                "route53:ListVPCAssociationAuthorizations",
                "route53:ChangeResourceRecordSets",
                "route53:CreateVPCAssociationAuthorization",
                "route53:CreateTrafficPolicyInstance",
                "route53:ListTagsForResource",
                "route53:DeleteVPCAssociationAuthorization",
                "route53:ListTagsForResources",
                "route53:ListTrafficPolicyInstancesByPolicy",
                "route53:GetHostedZoneLimit",
                "route53:AssociateVPCWithHostedZone",
                "route53:GetTrafficPolicy"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/*",
                "arn:aws:route53:::trafficpolicyinstance/*",
                "arn:aws:route53:::healthcheck/*",
                "arn:aws:route53:::trafficpolicy/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_policy" "admin_group_amplify" {
  name        = "aws_iam_policy_group_amplify_${var.group_name}"
  description = "maintainers policy allowing amplify operations"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "VisualEditor7",
          "Effect": "Allow",
          "Action": [
            "amplify:GetJob",
            "amplify:ListArtifacts",
            "amplify:ListJobs",
            "amplify:DeleteJob",
            "amplify:StartDeployment",
            "amplify:CreateDeployment",
            "amplify:CreateApp",
            "amplify:StartJob",
            "amplify:ListApps",
            "amplify:GetApp",
            "amplify:StopJob",
            "amplify:UpdateApp"
          ],
          "Resource": "*"
        }

    ]
}
EOF
}


# --- policies <-> groups ---
resource "aws_iam_group_policy_attachment" "admin_group_main" {
  group      = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.admin_group_main.arn
}
resource "aws_iam_group_policy_attachment" "admin_group_route53" {
  group      = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.admin_group_route53.arn
}
resource "aws_iam_group_policy_attachment" "admin_group_amplify" {
  group      = aws_iam_group.admin.name
  policy_arn = aws_iam_policy.admin_group_amplify.arn
}
# --- policies <-> roles ---
resource "aws_iam_role_policy_attachment" "admin_group_main" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_group_main.arn
}
resource "aws_iam_role_policy_attachment" "admin_group_route53" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_group_route53.arn
}
resource "aws_iam_role_policy_attachment" "admin_group_amplify" {
  role       = aws_iam_role.admin_role.name
  policy_arn = aws_iam_policy.admin_group_amplify.arn
}












