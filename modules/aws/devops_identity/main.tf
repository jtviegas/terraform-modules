terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# -------    variables   -------

variable "devops_identity_group" {type = string}
variable "devops_identity_user" {type = string}

# --- queries ---
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# -------    resources   -------

# --- group ---
resource "aws_iam_group" "devops_identity" {
  name = var.devops_identity_group
}

# --- role ---

resource "aws_iam_role" "devops_identity" {
  name                = "aws_iam_role_${var.devops_identity_group}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

# --- policies ---

resource "aws_iam_policy" "devops_identity_main" {
  name        = "aws_iam_policy_main_${var.devops_identity_group}"
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

resource "aws_iam_policy" "devops_identity_route53" {
  name        = "aws_iam_policy_route53_${var.devops_identity_group}"
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

# --- policies <-> groups ---
resource "aws_iam_group_policy_attachment" "devops_identity_main" {
  group      = aws_iam_group.devops_identity.name
  policy_arn = aws_iam_policy.devops_identity_main.arn
}
resource "aws_iam_group_policy_attachment" "devops_identity_route53" {
  group      = aws_iam_group.devops_identity.name
  policy_arn = aws_iam_policy.devops_identity_route53.arn
}

# --- policies <-> roles ---
resource "aws_iam_role_policy_attachment" "devops_identity_main" {
  role       = aws_iam_role.devops_identity.name
  policy_arn = aws_iam_policy.devops_identity_main.arn
}
resource "aws_iam_role_policy_attachment" "devops_identity_route53" {
  role       = aws_iam_role.devops_identity.name
  policy_arn = aws_iam_policy.devops_identity_route53.arn
}

# --- user ---
resource "aws_iam_user" "devops_identity" {
  name = var.devops_identity_user
  force_destroy = true
}

resource "aws_iam_user_login_profile" "devops_identity" {
  user    = aws_iam_user.devops_identity.name
}
resource "aws_iam_user_group_membership" "devops_identity" {
  user    = aws_iam_user.devops_identity.name
  groups = [ var.devops_identity_group, ]
}
# --- root resource for dependency
resource "aws_iam_access_key" "devops_identity" {
  user    = aws_iam_user.devops_identity.name
}

# -------    outputs   -------

output "group_devops_identity_id" {
  value       = aws_iam_group.devops_identity.id
  description = "The group ID"
}

output "group_devops_identity_arn" {
  value       = aws_iam_group.devops_identity.arn
  description = "The ARN assigned by AWS for this group"
}

output "group_devops_identity_unique_id" {
  value       = aws_iam_group.devops_identity.unique_id
  description = "The unique ID assigned by AWS"
}

output "role_devops_identity_id" {
  value       = aws_iam_role.devops_identity.id
  description = "The role ID"
}

output "role_devops_identity_arn" {
  value       = aws_iam_role.devops_identity.arn
  description = "The role arn"
}

output "user_devops_identity_password" {
  value       = aws_iam_user_login_profile.devops_identity.encrypted_password
  description = "user encrypted password"
}
output "user_devops_identity_access_key" {
  value       = aws_iam_access_key.devops_identity.secret
  description = "user access key"
  sensitive = true
}

output "user_devops_identity_access_key_id" {
  value       = aws_iam_access_key.devops_identity.id
  description = "user access key id"
}