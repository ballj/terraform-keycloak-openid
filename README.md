# Terraform Keycloak OpenID

This terraform module creates an OpenID client on keycloak.

## Useage

```
module "openid" {
  source        = "ballj/openid/keycloak"
  version       = "~> 1.0"
  realm         = "example.com"
  client_id     = "https://application.example.com"
  name          = "myapp"
  access_type   = "CONFIDENTIAL"
}
```

## Variables
 
| Variable                                     | Required | Default      | Description                                         |
| -------------------------------------------- | -------- | ------------ | --------------------------------------------------- |
| `name`                                       | Yes      | N/A          | Display name of this client                         |
| `realm_id`                                   | Yes      | N/A          | Realm this client is attached to                    |
| `client_id`                                  | Yes      | N/A          | Client ID for this client                           |
| `description`                                | No       | `null`       | The description of this client in the GUI           |
| `enabled`                                    | No       | `true`       | Allow clients to initiate a login                   |
| `roles`                                      | No       | `[]`         | Roles to add to client                              |
| `access_type`                                | Yes      | N/A          | Specifies the type of client                        |
| `full_scope_allowed`                         | No       | `false`      | Allow to include all roles mappings in the token    |
| `standard_flow_enabled`                      | No       | `true`       | OAuth2 Authorization Code Grant will be enabled     |
| `implicit_flow_enabled`                      | No       | `false`      | OAuth2 Implicit Grant will be enabled               |
| `direct_access_grants_enabled`               | No       | `true`       | OAuth2 Resource Owner Password Grant is enabled     |
| `service_account_enabled`                    | No       | `false`      | OAuth2 Client Credentials grant will be enabled     |
| `valid_redirect_uris`                        | No       | `null`       | List of valid URIs                                  |
| `web_origins`                                | No       | `["*"]`      | List of allowed CORS origins                        |
| `root_url`                                   | No       | `null`       | URL is prepended to any relative URLs found         |
| `admin_url`                                  | No       | `null`       | URL to the admin interface of the client            |
| `base_url`                                   | No       | `false`      | URL to use when the auth server needs to redirect   |
| `pkce_code_challenge_method`                 | No       | `""`         | Challenge method to use for PKCE                    |
| `access_token_lifespan`                      | No       | `null`       | OAuth2 Implicit Grant will be enabled               |
| `client_offline_session_idle_timeout`        | No       | `null`       | Time a client offline session is allowed to be idle |
| `client_offline_session_max_lifespan `       | No       | `null`       | Max time before a client offline session is expired |
| `client_session_idle_timeout`                | No       | `null`       | Time a client session is allowed to be idle         |
| `client_session_max_lifespan`                | No       | `null`       | Max time before a client session is expired         |
| `consent_required`                           | No       | `false`      | Users have to consent to client access              |
| `login_theme`                                | No       | `null`       | Client login theme                                  |
| `exclude_session_state_from_auth_response`   | No       | `false`      | The parameter session_state will not be included    |
| `use_refresh_tokens`                         | No       | `true`       | refresh_token will be added to the token response   |
| `backchannel_logout_url`                     | No       | `null`       | URL that will cause the client to log itself out    |
| `backchannel_logout_session_required`        | No       | `true`       | Challenge method to use for PKCE                    |
| `backchannel_logout_revoke_offline_sessions` | No       | `false`      | revoke_offline_access included in the Logout Token  |
| `client_role_protocol_mappers`               | No       | `[]`         | User client role protocol mappers                   |
| `user_property_protocol_mappers`             | No       | `[]`         | User property protocol mappers                      |
| `full_name_protocol_mapper`                  | No       | `[]`         | User full name protocol mapper                      |
| `audience_protocol_mappers`                  | No       | `[]`         | Audience name protocol mappers                      |
| `keys_filter_algorithm`                      | No       | `[]`         | Keys will be filtered by algorithm                  |
| `keys_filter_status`                         | No       | `["ACTIVE"]` | Keys will be filtered by status                     |

## Roles

A list of roles can be provided:

```
module "openid" {
  role = [
    {
      name        = "admin",
      description = "Admin role"
    }
  ]
}
```

## Role Mappers

### Client role mapper

Client role mappers can be configured by passing a list to `client_role_protocol_mappers`.
The variables can be found in the TF [openid_user_client_role_protocol_mapper](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_user_client_role_protocol_mapper).

```
module "openid" {
  client_role_protocol_mappers = [
    {
      name        = "user-role",
      claim_name  = "roles"
    }
  ]
}
```

### User property mapper

User property mappers can be configured by passing a list to `user_property_protocol_mappers`.
The variables can be found in the TF [openid_user_property_protocol_mapper](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_user_property_protocol_mapper).

```
module "openid" {
 user_property_protocol_mappers = [
    {
      name = "username"
      user_property = "username"
      claim_name = "preferred_username"
      claim_value_type = "String"
    },
    {
      name = "email"
      user_property = "email"
      claim_name = "email"
      claim_value_type = "String"
    },
    {
      name = "family name"
      user_property = "lastName"
      claim_name = "family_name"
      claim_value_type = "String"
    },
    {
      name = "given name"
      user_property = "firstName"
      claim_name = "given_name"
      claim_value_type = "String"
    }
  ]
}
```
### Full name mapper

Full Name mappers can be configured by passing a list to `full_name_protocol_mapper`.
The variables can be found in the TF [openid_full_name_protocol_mapper](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_full_name_protocol_mapper).

```
module "openid" {
  full_name_protocol_mapper = {
    name = "name"
  }
}
```

### Audience protocol mapper

Audience protocol mappers can be configured by passing a list to `audience_protocol_mappers`.
The variables can be found in the TF [openid_audience_protocol_mapper](https://registry.terraform.io/providers/mrparkers/keycloak/latest/docs/resources/openid_audience_protocol_mapper).

```
module "openid" {
  audience_protocol_mappers = [{
    name = "client_id"
  }]
}
```
