resource "random_pet" "name" {
  prefix = var.name
  length    = 2
  separator = "-"
}