locals {
    
  resources    = [ "/entities/{app}/{entity}", "/entities/{app}/{entity}/{id}" ]
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api-name}"
}

resource "aws_api_gateway_resource" "resources" {
  for_each      = local.resources
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part     = each.value
}

resource "aws_api_gateway_method" "resources-methods" {
  for_each      = aws_api_gateway_resource.resources
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = each.value.id
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda-integration-resources" {
  rest_api_id               = "${aws_api_gateway_rest_api.api.id}"
  for_each                  = aws_api_gateway_resource.resources
  resource_id               = each.value.id
  http_method               = values(aws_api_gateway_method.resources-methods)[each.key].http_method
  integration_http_method   = "POST"
  type                      = "AWS_PROXY"
  uri                       = "${aws_lambda_function.lambda.invoke_arn}"
}

resource "aws_api_gateway_deployment" "deployment-resources" {
  depends_on = values(aws_api_gateway_integration.lambda-integration-resources)

  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"

  variables = {
    "dummy" = "xpto"
  }
} 

resource "aws_lambda_permission" "lambda-permission-resources" {
  for_each      = aws_api_gateway_resource.resources
  statement_id  = "AllowExecutionFromAPIGateway_${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account-id}:${aws_api_gateway_rest_api.api.id}/*/${values(aws_api_gateway_method.resources-methods)[each.key].http_method}${each.value.path}"
}



resource "aws_lambda_function" "lambda" {
  filename      = "${var.lambda-artifact}"
  function_name = "${var.lambda-name}"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "index.handler"

  runtime = "nodejs8.10"
  memory_size = 1024
  timeout = 60

}

resource "aws_iam_role" "lambda-role" {
  name = "${var.lambda-role}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# --- policies ---
resource "aws_iam_policy" "lambda-role-policy" {
  name        = "${var.lambda-role-policy}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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
resource "aws_iam_role_policy_attachment" "lambda-role-policy" {
  role       = "${aws_iam_role.lambda-role.name}"
  policy_arn = "${aws_iam_policy.lambda-role-policy.arn}"
}

# --- tables ---
module "tables" {
  source = "../simple-table"
  for_each = toset(var.tables)
  name     = each.value

}
