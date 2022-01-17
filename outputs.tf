output "client_id" {
  value = keycloak_openid_client.main.client_id
}

output "resource_id" {
  value = keycloak_openid_client.main.id
}

output "client_secret" {
  value     = keycloak_openid_client.main.client_secret
  sensitive = true
}

output "roles" {
  value = { for role in keycloak_role.main : role.name => role.id }
}

output "realm_keys" {
  value = data.keycloak_realm_keys.main.keys
}
