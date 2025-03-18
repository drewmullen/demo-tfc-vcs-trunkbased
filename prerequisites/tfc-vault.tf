# Create trust between specific workspace (or project) and Vault
# Then a variable set used to set 4 variables in the workspace which 
#   instruct the Terraform Cloud agent to authenticate with Vault


##################################
# Vault related resources
##################################

resource "vault_jwt_auth_backend" "tfc_jwt" {
  path               = "jwt-tfc-demo"
  type               = "jwt"
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}


resource "vault_jwt_auth_backend_role" "vault_admin" {
  backend   = vault_jwt_auth_backend.tfc_jwt.path
  role_name = "vault-admin"
  token_policies = [
    vault_policy.vault_admin.name,
  ]

  bound_audiences = [
    "vault.workload.identity"
  ]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.organization}:project:${local.project_name}:workspace:*:run_phase:*"
  }

  user_claim = "terraform_full_workspace"
  role_type  = "jwt"
  token_ttl  = 7200
}

resource "vault_policy" "vault_admin" {
  name   = "vault-admin"
  policy = <<EOT
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}

##################################
# TFC Workspace Trust Resources
##################################
# 4 Environment variables set on the workspace:
# TFC_VAULT_PROVIDER_AUTH = true
# TFC_VAULT_RUN_ROLE      = vault role name
# TFC_VAULT_AUTH_PATH     = path to the JWT auth backend
# TFC_VAULT_ADDR          = address of the Vault instance

resource "tfe_variable_set" "vault_admin_auth_role" {
  organization = var.organization
  name         = local.project_name
}

resource "tfe_variable" "enable_vault_provider_auth" {
  variable_set_id = tfe_variable_set.vault_admin_auth_role.id

  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_role" {
  variable_set_id = tfe_variable_set.vault_admin_auth_role.id

  key      = "TFC_VAULT_RUN_ROLE"
  value    = vault_jwt_auth_backend_role.vault_admin.role_name
  category = "env"

  description = "The Vault role runs will use to authenticate."
}

resource "tfe_variable" "tfc_vault_auth_path" {
  variable_set_id = tfe_variable_set.vault_admin_auth_role.id

  key      = "TFC_VAULT_AUTH_PATH"
  value    = vault_jwt_auth_backend.tfc_jwt.path
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_addr" {
  variable_set_id = tfe_variable_set.vault_admin_auth_role.id

  key       = "TFC_VAULT_ADDR"
  value     = var.vault_addr
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
}

# Assign variable set to workspace
resource "tfe_workspace_variable_set" "vault_admin_auth_role" {
  workspace_id    = tfe_workspace.dev.id
  variable_set_id = tfe_variable_set.vault_admin_auth_role.id
}