locals {
  project_name = "demo-tfc-vcs-trunkbased"
}

resource "tfe_project" "app" {
  organization = var.organization
  name         = local.project_name
}

resource "tfe_workspace" "dev" {
    name         = "dev"
    organization = var.organization
    project_id   = tfe_project.app.id

    auto_apply            = true
    queue_all_runs        = true
    file_triggers_enabled = true
    trigger_patterns      = [
      "envs/dev/**/*",
    #   "./*"
    ]
    vcs_repo {
        branch     = "main"
        identifier = "drewmullen/demo-tfc-vcs-trunkbased"
        
        github_app_installation_id = "ghain-gurYHzDBdnByPE5g"
    }
}

resource "tfe_variable" "dev_cli_args" {
    key          = "TF_CLI_ARGS"
    value        = "-var-file=envs/dev/dev.tfvars -var-file=envs/common.tfvars"
    category     = "env"
    workspace_id = tfe_workspace.dev.id
}

resource "tfe_workspace" "prod" {
    name         = "prod"
    organization = var.organization
    project_id   = tfe_project.app.id

    auto_apply            = true
    queue_all_runs        = true
    file_triggers_enabled = true
    trigger_patterns      = [
      "envs/prod/**/*"
    ]
    vcs_repo {
        branch     = "main"
        identifier = "drewmullen/demo-tfc-vcs-trunkbased"
        
        github_app_installation_id = "ghain-gurYHzDBdnByPE5g"
    }
}

resource "tfe_variable" "prod_cli_args" {
    key          = "TF_CLI_ARGS"
    value        = "-var-file=envs/prod/prod.tfvars -var-file=envs/common.tfvars"
    category     = "env"
    workspace_id = tfe_workspace.prod.id
}