resource "aws_cloudwatch_log_group" "sample" {
  name = "/aws/lambda/${var.service_name}-${var.env}"

  retention_in_days = 7
}

resource "aws_iam_role" "sample" {
  name = "iam-role-${var.service_name}-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  ]
  inline_policy {
    name = "iam-policy-${var.service_name}-${var.env}"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "logs:*"
          Resource = "${aws_cloudwatch_log_group.sample.arn}"
        }
      ]
    })
  }
}

resource "aws_lambda_layer_version" "sample" {
  filename   = "layer.zip"
  layer_name = "sample-layer"

  compatible_runtimes      = ["python3.8", "python3.9"]
  compatible_architectures = ["x86_64", "arm64"]
  source_code_hash         = filebase64sha256("${path.module}/layer.zip")
}

resource "aws_lambda_function" "sample" {
  function_name    = "${var.service_name}-${var.env}"
  role             = aws_iam_role.sample.arn
  runtime          = "python3.9"
  package_type     = "Zip"
  filename         = "${path.module}/package.zip"
  handler          = "main.handler"
  source_code_hash = filebase64sha256("${path.module}/package.zip")

  layers = [ aws_lambda_layer_version.sample.arn ]

  environment {
    variables = {
      ENV = var.env
    }
  }
}
