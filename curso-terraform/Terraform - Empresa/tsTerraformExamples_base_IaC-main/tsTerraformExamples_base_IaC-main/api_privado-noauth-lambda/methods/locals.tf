locals {
  apigateway_resources_lambda = {
    "metodo1" = {
      resource_id             = aws_api_gateway_resource.v1.id
      http_method             = "POST"
      authorization           = "NONE"
      authorization_scopes    = [""]
      api_key_required        = true
      integration_uri         = module.lambda_mod.aws_lambda_invoke_arn
      integration_type        = "AWS_PROXY"
      integration_http_method = "POST"
      status_code             = 200
      method_request_parameters = {
        "method.request.path.roleId" = true
      }
      method_response_parameters = {}
      integration_request_parameters = {
        "integration.request.path.roleId" = "method.request.path.roleId"
      }
      integration_response_parameters = {}
      request_templates               = {}
      response_models                 = {}
    },
    "metodo2" = {
      resource_id                     = aws_api_gateway_resource.v1.id
      http_method                     = "GET"
      authorization                   = "NONE"
      authorization_scopes            = [""]
      api_key_required                = true
      integration_uri                 = module.lambda_mod.aws_lambda_invoke_arn
      integration_type                = "AWS_PROXY"
      integration_http_method         = "GET"
      status_code                     = 200
      method_request_parameters       = {}
      method_response_parameters      = {}
      integration_request_parameters  = {}
      integration_response_parameters = {}
      request_templates               = {}
      response_models                 = {}
    },
    "metodo3" = {
      resource_id                     = aws_api_gateway_resource.v1.id
      http_method                     = "PUT"
      authorization                   = "NONE"
      authorization_scopes            = [""]
      api_key_required                = true
      integration_uri                 = module.lambda_mod.aws_lambda_invoke_arn
      integration_type                = "AWS_PROXY"
      integration_http_method         = "PUT"
      status_code                     = 200
      method_request_parameters       = {}
      method_response_parameters      = {}
      integration_request_parameters  = {}
      integration_response_parameters = {}
      request_templates               = {}
      response_models                 = {}
    }
  }
}
