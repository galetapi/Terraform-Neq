locals {

  apigateway_resources_vpclink = {
    "metodo1" = {
      resource_id             = aws_api_gateway_resource.v1.id
      http_method             = "POST"
      authorization           = "COGNITO_USER_POOLS"
      authorization_scopes    = ["test/uno"]
      api_key_required        = true
      integration_uri         = "https://albecsterraformExamplesdev.bancadigital.com.co/endpoint-one"
      integration_type        = "HTTP"
      integration_conn_type   = "VPC_LINK"
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
      authorization                   = "COGNITO_USER_POOLS"
      authorization_scopes            = ["test/uno"]
      api_key_required                = true
      integration_uri                 = "https://albecsterraformExamplesdev.bancadigital.com.co/"
      integration_type                = "HTTP"
      integration_conn_type           = "VPC_LINK"
      integration_http_method         = "GET"
      status_code                     = 200
      method_request_parameters       = {}
      method_response_parameters      = {}
      integration_request_parameters  = {}
      integration_response_parameters = {}
      request_templates               = {}
      response_models                 = {}
    }
  }

  task_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "StsROLE",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.capacity}-${var.functionality}-task-role-${var.env}"
    }
  ]
}
EOF

  container_variables_secrets = {

    secretsArn = [
      # {
      #   arn = "arn:aws:secretsmanager:us-east-1:634614730521:secret:secret-jarvisrev-co-testapi-dev-KZC44U"
      # }
    ],

    secrets = [
      # {
      #   name      = "CHECKLIST_API_KEY"
      #   ValueFrom = "arn:aws:secretsmanager:us-east-1:634614730521:secret:secret-jarvisrev-co-testapi-dev-KZC44U"
      # }
    ],

    environment = [
      {
        name  = "TEST_PATH"
        value = "/api/v1/test/{region}/{number}"
      }
    ]
  }
}
