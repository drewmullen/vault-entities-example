# locals {
#   org = split("/",var.TFC_WORKSPACE_SLUG)[0]
#   ws_name = split("/",var.TFC_WORKSPACE_SLUG)[1]
# }

resource "tfe_project" "demo" {
  organization = var.org
  name         = "vault-entities-workspace-test-project"
  description  = "A demo project for Vault Workload Identity integration."
}

resource "tfe_project_variable_set" "vault_admin_auth_role" {
  variable_set_id = tfe_variable_set.vault_admin.id
  project_id = tfe_project.demo.id
}

resource "tfe_variable_set" "vault_admin" {
  organization = var.org
  name         = tfe_project.demo.name
  description  = "Variables for Vault Workload Identity integration for TFC runs."
}

resource "tfe_variable" "enable_vault_provider_auth" {
  variable_set_id = tfe_variable_set.vault_admin.id

  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "vault" {
  variable_set_id = tfe_variable_set.vault_admin.id

  key      = "TFC_VAULT_NAMESPACE"
  value    = "admin/entities"
  category = "env"

  description = "The Vault namespace the runs will use to authenticate."
}
resource "tfe_variable" "tfc_vault_role" {
  variable_set_id = tfe_variable_set.vault_admin.id

  key      = "TFC_VAULT_RUN_ROLE"
  value    = "workspace" #vault_jwt_auth_backend_role.vault_admin.role_name
  category = "env"

  description = "The Vault role runs will use to authenticate."
}

resource "tfe_variable" "tfc_vault_auth_path" {
  variable_set_id = tfe_variable_set.vault_admin.id

  key      = "TFC_VAULT_AUTH_PATH"
  value    = "tfc" # vault_jwt_auth_backend.tfc_jwt.path
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_addr" {
  variable_set_id = tfe_variable_set.vault_admin.id

  key       = "TFC_VAULT_ADDR"
  value     = var.vault_addr
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
}
