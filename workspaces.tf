resource "vault_identity_entity" "workspace_app1_dev" {
  name = "App 1 Friendly Name - DEV (TFE Workspace)"
  metadata = {
    Application = "Terraform Enterprise"
    Type        = "Workspace"
    
    # NOTE: Here be dragons! Changing the below fields will alter permissions!
    AppID       = "app1" # ... or whatever unique id is in the other system
    Environment = "dev"
  }
  
  policies = [
    vault_policy.entity_based_kv.name,
    vault_policy.workspace_app1.name,
  ]
}

resource "vault_identity_entity_alias" "workspace_app1_dev" {
  name           = "vault-entities-workspace-test" # Workspace id for "my-org/my-workspace"
  mount_accessor = vault_jwt_auth_backend.tfc.accessor
  canonical_id   = vault_identity_entity.workspace_app1_dev.id
}

data "vault_policy_document" "workspace_app1" {
  # Some specific rules that only apply to this 1 workspace...
  rule {
    description  = "Read bearer token managed by some other team"
    path         = "kv/data/app1/workspace/*"
    capabilities = ["read"]
  }
}
resource "vault_policy" "workspace_app1" {
  name   = "tfe-ws-app1"
  policy = data.vault_policy_document.workspace_app1.hcl
}

# resource "vault_identity_entity" "workspace_app1_stage" {
#   name = "App 1 Friendly Name - STAGE (TFE Workspace)"
#   metadata = {
#     Application = "Terraform Enterprise"
#     Type        = "Workspace"
    
#     # NOTE: Here be dragons! Changing the below fields will alter permissions!
#     AppID       = "app1" # ... or whatever unique id is in the other system
#     Environment = "stage"
#   }
  
#   policies = [
#     vault_policy.entity_based_kv.name,
#     vault_policy.workspace_app1.name,
#   ]
# }
# resource "vault_identity_entity_alias" "workspace_app1_stage" {
#   name           = "ws-mbsd5E3Ktd5Rg5bE" # Workspace id for "my-org/my-workspace"
#   mount_accessor = vault_jwt_auth_backend.tfe.accessor
#   canonical_id   = vault_identity_entity.workspace_app1_stage.id
# }