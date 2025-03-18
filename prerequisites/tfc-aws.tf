resource "vault_aws_secret_backend" "aws_secret_backend" {
  path       = "aws"
  access_key = data.environment_variable.aws_access_key.value
  secret_key = data.environment_variable.aws_secret_key.value
}

resource "vault_aws_secret_backend_role" "aws_secret_backend_role" {
  backend         = vault_aws_secret_backend.aws_secret_backend.path
  name            = "personal-demo-role-ssm"
  credential_type = "iam_user"
  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ssm:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# 3 variables for dynamic AWS Vault backend authentication
# TFC_VAULT_BACKED_AWS_AUTH = true
# TFC_VAULT_BACKED_AWS_AUTH_TYPE = iam_user
# TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE = personal-demo-role-ssm

resource "tfe_variable_set" "aws_vault_backend" {
  organization = var.organization
  name         = "${local.project_name}-aws"
}

resource "tfe_variable" "enable_vault_backend_aws_auth" {
  variable_set_id = tfe_variable_set.aws_vault_backend.id

  key      = "TFC_VAULT_BACKED_AWS_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Vault AWS backend authentication."
}

resource "tfe_variable" "tfc_vault_backend_aws_auth_type" {
  variable_set_id = tfe_variable_set.aws_vault_backend.id

  key      = "TFC_VAULT_BACKED_AWS_AUTH_TYPE"
  value    = vault_aws_secret_backend_role.aws_secret_backend_role.credential_type
  category = "env"

  description = "The type of AWS credential to use for Vault authentication."
}

resource "tfe_variable" "tfc_vault_backend_aws_run_vault_role" {
  variable_set_id = tfe_variable_set.aws_vault_backend.id

  key      = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE"
  value    = vault_aws_secret_backend_role.aws_secret_backend_role.name
  category = "env"

  description = "The Vault role to use for AWS authentication."
}

# Assign variable set to workspace
resource "tfe_workspace_variable_set" "aws_vault_backend" {
  workspace_id    = tfe_workspace.dev.id
  variable_set_id = tfe_variable_set.aws_vault_backend.id
}