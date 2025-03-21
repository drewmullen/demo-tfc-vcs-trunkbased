resource "random_pet" "name" {
  prefix = var.name
  length    = 2
  separator = "-"
}

resource "aws_ssm_parameter" "name" {
  name  = "/${var.name}/app_name"
  type  = "String"
  value = random_pet.name.id
}
