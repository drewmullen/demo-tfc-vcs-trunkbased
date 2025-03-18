variable "organization" {
  default = "mullen-hashi"
}

variable "vault_addr" {
  type        = string
  description = "The URL of the Vault instance you'd like to use with Terraform Cloud"
  default     = "https://vault-hashicorp-vault.apps.homelab.drewbuntu.com"
}

