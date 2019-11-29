locals{
  lambda_name = "entity-loader"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.api-name}-${var.environment}"
}

resource "aws_api_gateway_resource" "resources-base" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part     = "entities"
}
resource "aws_api_gateway_resource" "resources-app" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_resource.resources-base.id}"
  path_part     = "{app}"
}

resource "aws_api_gateway_resource" "resources-entity" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_resource.resources-app.id}"
  path_part     = "{entity}"
}
resource "aws_api_gateway_resource" "resources-id" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  parent_id     = "${aws_api_gateway_resource.resources-entity.id}"
  path_part     = "{id}"
}


resource "aws_api_gateway_method" "resources-entity-methods" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resources-entity.id}"
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda-integration-resources-entity" {
  rest_api_id               = "${aws_api_gateway_rest_api.api.id}"
  resource_id               = "${aws_api_gateway_resource.resources-entity.id}"
  http_method               = "${aws_api_gateway_method.resources-entity-methods.http_method}"
  integration_http_method   = "POST"
  type                      = "AWS_PROXY"
  uri                       = "${aws_lambda_function.lambda.invoke_arn}"
}
resource "aws_api_gateway_deployment" "deployment-resources-entity" {
  depends_on    = [ aws_api_gateway_integration.lambda-integration-resources-entity ]
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"

  variables = {
    "dummy" = "xpto"
  }
} 
resource "aws_lambda_permission" "lambda-permission-resources-entity" {
  statement_id  = "AllowExecutionFromAPIGateway-resources-entity"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account-id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.resources-entity-methods.http_method}${aws_api_gateway_resource.resources-entity.path}"
}


resource "aws_api_gateway_method" "resources-id-methods" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.resources-id.id}"
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda-integration-resources-id" {
  rest_api_id               = "${aws_api_gateway_rest_api.api.id}"
  resource_id               = "${aws_api_gateway_resource.resources-id.id}"
  http_method               = "${aws_api_gateway_method.resources-id-methods.http_method}"
  integration_http_method   = "POST"
  type                      = "AWS_PROXY"
  uri                       = "${aws_lambda_function.lambda.invoke_arn}"
}
resource "aws_api_gateway_deployment" "deployment-resources-id" {
  depends_on    = [ aws_api_gateway_integration.lambda-integration-resources-id ]
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"

  variables = {
    "dummy" = "xpto"
  }
} 
resource "aws_lambda_permission" "lambda-permission-resources-id" {
  statement_id  = "AllowExecutionFromAPIGateway-resources-id"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.account-id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.resources-id-methods.http_method}${aws_api_gateway_resource.resources-id.path}"
}


resource "aws_lambda_function" "lambda" {
  filename      = "${var.lambda-artifact}"
  function_name = "${var.api-name}-${var.environment}-${local.lambda_name}"
  role          = "${aws_iam_role.lambda-role.arn}"
  handler       = "index.handler"

  runtime = "nodejs8.10"
  memory_size = 1024
  timeout = 60

}

resource "aws_iam_role" "lambda-role" {
  name = "${var.api-name}-${var.environment}-${local.lambda_name}-role"

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
  name        = "${var.api-name}-${var.environment}-${local.lambda_name}-role-policy"
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
#module "tables" {
#    source = "../simple-tables"
#    names     = var.tables
#}
