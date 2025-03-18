resource "tfe_project" "app" {
  organization = "mullen-hashi"
  name         = "demo-tfc-vcs-trunkbased"
}

resource "tfe_workspace" "dev" {
    name         = "dev"
    organization = "mullen-hashi"
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
    value        = "-var-file=envs/dev/terraform.tfvars -var-file=envs/common.tfvars"
    category     = "env"
    workspace_id = tfe_workspace.dev.id
}

resource "tfe_workspace" "prod" {
    name         = "prod"
    organization = "mullen-hashi"
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