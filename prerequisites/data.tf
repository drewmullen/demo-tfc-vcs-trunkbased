data "environment_variable" "aws_access_key" {
  name = "AWS_ACCESS_KEY_ID"
}

data "environment_variable" "aws_secret_key" {
  name = "AWS_SECRET_ACCESS_KEY"
}
