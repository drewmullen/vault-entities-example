resource "vault_jwt_auth_backend" "tfc" {
  type = "jwt"
  path = "tfc"
  
  oidc_discovery_url = "https://app.terraform.io"
  bound_issuer       = "https://app.terraform.io"
}

resource "vault_jwt_auth_backend_role" "tfc_workspace" {
  backend = vault_jwt_auth_backend.tfc.path
  
  role_type    = "jwt"
  role_name    = "workspace"
  user_claim   = "terraform_workspace_name"
  groups_claim = "terraform_project_name"
  
  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    # See https://developer.hashicorp.com/terraform/enterprise/workspaces/dynamic-provider-credentials/workload-identity-tokens#custom-claims
    # for list of claims that can be used to limit access to this role (and therefore limiting allocation of client licenses)
    "terraform_organization_name"   = "mullen-hashi"
  }
  claim_mappings = {
    terraform_organization_id   = "org_id"
    terraform_organization_name = "org_name"
    terraform_project_id        = "project_id"
    terraform_project_name      = "project_name"
    terraform_workspace_id      = "workspace_id"
    terraform_workspace_name    = "workspace_name"
    
    # NOTE: These are helpful for troubleshooting via Vault audit logs, but can lead to high churn and performance issues. Enable at your own risk:
    # terraform_run_id    = "run_id"
    # terraform_run_phase = "run_phase"
  }
  
  token_policies          = [vault_policy.baseline_tfc.name]
  token_no_default_policy = true
}

data "vault_policy_document" "baseline_tfc" {
  rule {
    description  = "Allow tokens to query themselves"
    path         = "auth/token/lookup-self"
    capabilities = ["read"]
  }
  rule {
    description  = "Allow tokens to renew themselves"
    path         = "auth/token/renew-self"
    capabilities = ["update"]
  }
  rule {
    description  = "Allow tokens to revoke themselves"
    path         = "auth/token/revoke-self"
    capabilities = ["update"]
  }
}

resource "vault_policy" "baseline_tfc" {
  name   = "baseline-tfc"
  policy = data.vault_policy_document.baseline_tfc.hcl
}

### Generic entity based kv secrets

data "vault_policy_document" "entity_based_kv" {
  rule {
    description  = "Read secrets and metadata for own AppID"
    path         = "kv/+/{{ identity.entity.metadata.AppID }}/*"
    capabilities = ["read"]
  }
}
resource "vault_policy" "entity_based_kv" {
  name   = "baseline-tfc-secrets"
  policy = data.vault_policy_document.entity_based_kv.hcl
}