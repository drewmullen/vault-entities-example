terraform {
  cloud {
    workspaces {
      project = "vault-entities-workspace-test-project"
      name = "vault-entities-workspace-test"
    }
    organization = "mullen-hashi"
  }
}

data "vault_kv_secret_v2" "test_succeed" {
  mount = "kv"
  name  = "test"
}

data "vault_kv_secret_v2" "app1_test" {
  mount = "kv"
  name  = "app1/test"
}

data "vault_kv_secret_v2" "app1_ws_test" {
  mount = "kv"
  name  = "app1/workspace/test"
}


provider "vault" {
  namespace = "admin/entities"
}