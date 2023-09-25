terraform {
  required_version = ">= 0.12.0"
  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 3.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}

data "keycloak_realm" "main" {
  realm = var.realm
}

data "keycloak_realm_keys" "main" {
  realm_id   = data.keycloak_realm.main.id
  algorithms = var.keys_filter_algorithm
  status     = var.keys_filter_status
}

data "keycloak_group" "main" {
  for_each = toset([for role in var.roles : role.group if contains(keys(role), "group")])
  realm_id = data.keycloak_realm.main.id
  name     = each.key
}

resource "keycloak_openid_client" "main" {
  realm_id  = data.keycloak_realm.main.id
  client_id = var.client_id

  name        = var.name
  description = var.description
  enabled     = var.enabled

  access_type                  = var.access_type
  full_scope_allowed           = var.full_scope_allowed
  standard_flow_enabled        = var.standard_flow_enabled
  implicit_flow_enabled        = var.implicit_flow_enabled
  direct_access_grants_enabled = var.direct_access_grants_enabled
  service_accounts_enabled     = var.service_account_enabled

  root_url            = var.root_url
  base_url            = var.base_url
  valid_redirect_uris = var.valid_redirect_uris
  web_origins         = var.web_origins
  admin_url           = var.admin_url
  login_theme         = var.login_theme
  consent_required    = var.consent_required
  use_refresh_tokens  = var.use_refresh_tokens

  backchannel_logout_url                     = var.backchannel_logout_url
  backchannel_logout_session_required        = var.backchannel_logout_session_required
  backchannel_logout_revoke_offline_sessions = var.backchannel_logout_revoke_offline_sessions

  pkce_code_challenge_method               = var.pkce_code_challenge_method
  exclude_session_state_from_auth_response = var.exclude_session_state_from_auth_response

  access_token_lifespan               = var.access_token_lifespan
  client_session_idle_timeout         = var.client_session_idle_timeout
  client_session_max_lifespan         = var.client_session_max_lifespan
  client_offline_session_idle_timeout = var.client_offline_session_idle_timeout
  client_offline_session_max_lifespan = var.client_offline_session_max_lifespan
}

resource "keycloak_role" "main" {
  for_each    = { for role in var.roles : role.name => role }
  realm_id    = data.keycloak_realm.main.id
  client_id   = keycloak_openid_client.main.id
  name        = each.key
  description = lookup(each.value, "description", null)
  attributes  = lookup(each.value, "attributes", {})
}

resource "keycloak_group_roles" "main" {
  for_each = { for role in var.roles : role.name => role if contains(keys(role), "group") }
  realm_id = data.keycloak_realm.main.id
  group_id = data.keycloak_group.main[each.value.group].id

  role_ids = [
    keycloak_role.main[each.key].id
  ]
}

resource "keycloak_openid_user_client_role_protocol_mapper" "roles" {
  for_each                    = { for client_role in var.client_role_protocol_mappers : client_role.name => client_role }
  realm_id                    = data.keycloak_realm.main.id
  client_id                   = keycloak_openid_client.main.id
  name                        = each.key
  claim_name                  = each.value.claim_name
  claim_value_type            = lookup(each.value, "claim_value_type", "String")
  multivalued                 = lookup(each.value, "multivalued", false)
  client_id_for_role_mappings = lookup(each.value, "client_id_for_role_mappings", keycloak_openid_client.main.client_id)
  client_role_prefix          = lookup(each.value, "client_role_prefix", null)
  add_to_id_token             = lookup(each.value, "add_to_id_token", true)
  add_to_access_token         = lookup(each.value, "add_to_access_token", true)
  add_to_userinfo             = lookup(each.value, "add_to_userinfo", true)
}

resource "keycloak_openid_user_property_protocol_mapper" "main" {
  for_each            = { for user_property in var.user_property_protocol_mappers : user_property.name => user_property }
  realm_id            = data.keycloak_realm.main.id
  client_id           = keycloak_openid_client.main.id
  name                = each.key
  user_property       = each.value.user_property
  claim_name          = each.value.claim_name
  claim_value_type    = lookup(each.value, "claim_value_type", "String")
  add_to_id_token     = lookup(each.value, "add_to_id_token", true)
  add_to_access_token = lookup(each.value, "add_to_access_token", true)
  add_to_userinfo     = lookup(each.value, "add_to_userinfo", true)
}

resource "keycloak_openid_user_attribute_protocol_mapper" "main" {
  for_each             = { for user_attribute in var.user_attribute_protocol_mappers : user_attribute.name => user_attribute }
  realm_id             = data.keycloak_realm.main.id
  client_id            = keycloak_openid_client.main.id
  name                 = each.key
  user_attribute       = each.value.user_attribute
  claim_name           = each.value.claim_name
  claim_value_type     = lookup(each.value, "claim_value_type", "String")
  multivalued          = lookup(each.value, "multivalued", false)
  add_to_id_token      = lookup(each.value, "add_to_id_token", true)
  add_to_access_token  = lookup(each.value, "add_to_access_token", true)
  add_to_userinfo      = lookup(each.value, "add_to_userinfo", true)
  aggregate_attributes = lookup(each.value, "aggregate_attributes", false)
}

resource "keycloak_openid_full_name_protocol_mapper" "main" {
  count               = var.full_name_protocol_mapper != null ? 1 : 0
  realm_id            = data.keycloak_realm.main.id
  client_id           = keycloak_openid_client.main.id
  name                = var.full_name_protocol_mapper.name
  add_to_id_token     = lookup(var.full_name_protocol_mapper, "add_to_id_token", true)
  add_to_access_token = lookup(var.full_name_protocol_mapper, "add_to_access_token", true)
  add_to_userinfo     = lookup(var.full_name_protocol_mapper, "add_to_userinfo", true)
}

resource "keycloak_openid_audience_protocol_mapper" "main" {
  for_each                 = { for audience in var.audience_protocol_mappers : audience.name => audience }
  realm_id                 = data.keycloak_realm.main.id
  client_id                = keycloak_openid_client.main.id
  name                     = each.key
  included_client_audience = lookup(each.value, "included_client_audience", keycloak_openid_client.main.client_id)
  included_custom_audience = lookup(each.value, "included_custom_audience", null)
  add_to_id_token          = lookup(each.value, "add_to_id_token", true)
  add_to_access_token      = lookup(each.value, "add_to_access_token", true)
}
