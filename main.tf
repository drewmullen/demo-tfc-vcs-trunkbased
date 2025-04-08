resource "random_pet" "name" {
  prefix = var.name
  length    = 2
  separator = "-"
}

resource "aws_ssm_parameter" "name" {
  name  = data.vault_generic_secret.name.data["name"]  #"/${var.name}/app_name"
  type  = "String"
  value = random_pet.name.id
}

data "vault_generic_secret" "name" {
  path = "kvv2/data/test"
}

provider "vault" {
  skip_tls_verify = true
}