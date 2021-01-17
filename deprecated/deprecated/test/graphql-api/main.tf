module "graphql-api" {
  source = "../../modules/aws/graphql-api"
  api = "${var.api}"
  environment = "${var.environment}"
  function = "${var.function}"
  region = "${var.region}"
  function-artifact-location = "${var.function-artifact-location}"
  function-runtime = "${var.function-runtime}"
  function-memory = "${var.function-memory}"
  function-timeout = "${var.function-timeout}"
}

output "endpoint" {
  value       = module.graphql-api.invoke_url
  description = "The URL to invoke the API pointing to the stage, e.g. https://z4675bid1j.execute-api.eu-west-2.amazonaws.com/prod"
}

