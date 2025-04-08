resource "random_pet" "name" {
  prefix = var.name
  length    = 2
  separator = "-"
}

# resource "aws_ssm_parameter" "name" {
#   name  = data.vault_generic_secret.name.data["name"]  #"/${var.name}/app_name"
#   type  = "String"
#   value = random_pet.name.id
# }

data "vault_generic_secret" "name" {
  path = "kvv2/test"
}

output "name" {
  value = data.vault_generic_secret.name.data["name"]
  sensitive = true
}

resource "vault_generic_secret" "test" {
  path = "kvv2/test2"
  data_json = jsonencode({
    name = random_pet.name.id
  })
}

provider "vault" {
  skip_tls_verify = true
}