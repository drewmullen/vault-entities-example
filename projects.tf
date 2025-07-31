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
import {
  id = "b9296e95-1c88-5f32-ade0-3d4e7ced9687"
  to = vault_identity_entity_alias.workspace_app1_dev
}