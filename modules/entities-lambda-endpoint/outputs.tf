
output "resource-id" {
  value       = values(aws_api_gateway_resource.resources)[*].id
}

output "resource-path" {
  value       = values(aws_api_gateway_resource.resources)[*].path
}

output "invoke-url" {
    value       = values(aws_api_gateway_deployment.deployment-resources)[*].invoke_url
    description = "The URL to invoke the API pointing to the stage, e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
}

output "execution-arn" {
    value       = values(aws_api_gateway_deployment.deployment-resources)[*].execution_arn
    description = "The execution ARN to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function, e.g. arn:aws:execute-api:eu-west-2:123456789012:z4675bid1j/prod"
}

output "tables-arn" {
  value       = module.tables.arns
}