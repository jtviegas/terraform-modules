# --- roles ---
resource "aws_iam_role" "lambda-role" {
  name = "${var.api}-${var.environment}-${var.function}-role"

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
resource "aws_iam_policy" "lambda-policy" {
  name        = "${var.api}-${var.environment}-${var.function}-policy"
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
  policy_arn = "${aws_iam_policy.lambda-policy.arn}"
}

resource "aws_lambda_function" "function" {
  filename      = "${var.function-artifact-location}"
  function_name = "${var.api}-${var.environment}-${var.function}"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "index.handler"

  runtime = "${var.function-runtime}"
  memory_size = "${var.function-memory}"
  timeout = "${var.function-timeout}"

}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api}-${var.environment}"
}

resource "aws_api_gateway_resource" "root-resource" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part     = "graphql"
}

resource "aws_api_gateway_method" "root-methods" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.root-resource.id}"
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "root-function" {
  rest_api_id               = "${aws_api_gateway_rest_api.api.id}"
  resource_id               = "${aws_api_gateway_resource.root-resource.id}"
  http_method               = "${aws_api_gateway_method.root-methods.http_method}"
  integration_http_method   = "POST"
  type                      = "AWS_PROXY"
  uri                       = "${aws_lambda_function.function.invoke_arn}"
}

resource "aws_api_gateway_deployment" "root-deployment" {
  depends_on    = [ aws_api_gateway_integration.root-function ]
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"
}

resource "aws_lambda_permission" "root-function-permission" {
  statement_id  = "AllowExecutionFromAPIGateway-root"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.function.function_name}"
  principal     = "apigateway.amazonaws.com"

  # references:
  # http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

