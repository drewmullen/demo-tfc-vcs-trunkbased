# Demo: TFC + VCS + trunk based development

Set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY

Goal of this demo is to showcase:
1. creating tfe_ resources 
1. using vcs repos
1. vault-backed secrets
1. aws dynamic secrets (iam user)

Preamble: 
- explain vcs driven workflow overview
- explain trunk based dev (1 root, n envs)

Prereqs:
- show repo in github
  - explain relationship to tfvars files
- tfvars could become variables on the workspace - not today!
- explain `main.tf` resources & arguments
- `terraform apply`
- show in tfc

First Build:
- uncomment random resource 
- `git switch -c create-random-pet; git commit -am 'build random pet resource'; git push origin create-random-pet` 
- create pr
- review plans 
- merge 

Adding in a provider that needs auth:

This is a pretty simple example to show the workflow. Next lets discuss another feature in TFC to assist in auth workflows. All providers need to authenticate to their destination APIs. show picture: https://www.hashicorp.com/_next/image?url=https%3A%2F%2Fwww.datocms-assets.com%2F2885%2F1682348441-vault-backed-dynamic-creds.png&w=3840&q=75

Using OIDC you can build a trust between Vault and TFC, allow specific tfc workspaces or projects access to a Vault role. TFC has a feature that allows it before a `plan` phase to auth to vault and check out secrets for use with a provider.

Vault:
- uncomment `tfc-vault.tf`
- walkthrough code
  - vault resources
  - tfe resources
- `terraform apply`
- uncomment ssm param + git push
- show failure

AWS:
- uncomment `tfc-aws.tf`
- walkthrough code
- `terraform apply`
- uncomment ssm param + git push
- show success
- show ssm param
