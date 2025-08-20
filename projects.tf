resource "vault_identity_group" "tfe_project_app1" {
  name = "App 1 (TFE)"
  type = "external"
  
  metadata = {
    # NOTE: these, by contrast with the entities, are not sensitive and are purely for human eyes/convenience
    AppID       = "app1"
    Description = "Collection of TFE workspaces ascribed to app1 project"
  }
  
  policies = [
    # TODO: Any shared permissions among all of App 1 environments.
  ]
}
resource "vault_identity_group_alias" "tfe_project_app1" {
  name           = "vault-entities-workspace-test-project"
  mount_accessor = vault_jwt_auth_backend.tfc.accessor
  canonical_id   = vault_identity_group.tfe_project_app1.id
}
