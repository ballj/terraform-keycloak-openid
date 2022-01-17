variable "secret_key" {
  type        = string
  description = "Kubernetes namespace to deploy into"
  default     = "client_secret"
}

variable "realm" {
  type        = string
  description = "Realm this client is attached to"
}

variable "client_id" {
  type        = string
  description = "Client ID for this client"
}

variable "name" {
  type        = string
  description = "Display name of this client"
}

variable "description" {
  type        = string
  description = "The description of this client in the GUI"
  default     = null
}

variable "enabled" {
  type        = bool
  description = "Allow clients to initiate a login or obtain access tokens"
  default     = true
}

variable "roles" {
  type        = any
  description = "Roles to add to client"
  default     = []
}

variable "access_type" {
  type        = string
  description = "Specifies the type of client [CONFIDENTIAL, PUBLIC, BEARER-ONLY]"
}

variable "full_scope_allowed" {
  type        = bool
  description = "Allow to include all roles mappings in the access token"
  default     = false
}

variable "standard_flow_enabled" {
  type        = bool
  description = "OAuth2 Authorization Code Grant will be enabled for this client"
  default     = true
}

variable "implicit_flow_enabled" {
  type        = bool
  description = "OAuth2 Implicit Grant will be enabled for this client"
  default     = false
}

variable "direct_access_grants_enabled" {
  type        = bool
  description = "OAuth2 Resource Owner Password Grant will be enabled for this client"
  default     = true
}

variable "service_account_enabled" {
  type        = bool
  description = "OAuth2 Client Credentials grant will be enabled for this client"
  default     = false
}

variable "valid_redirect_uris" {
  type        = list(string)
  description = "List of valid URIs a browser is permitted to redirect to after a successful login or logout"
  default     = null
}

variable "web_origins" {
  type        = list(string)
  description = "List of allowed CORS origins"
  default     = ["*"]
}

variable "root_url" {
  type        = string
  description = "URL is prepended to any relative URLs found"
  default     = null
}

variable "admin_url" {
  type        = string
  description = "URL to the admin interface of the client"
  default     = null
}

variable "base_url" {
  type        = string
  description = "Default URL to use when the auth server needs to redirect or link back to the client"
  default     = null
}

variable "pkce_code_challenge_method" {
  type        = string
  description = "The challenge method to use for Proof Key for Code Exchange"
  default     = ""
}

variable "access_token_lifespan" {
  type        = string
  description = "Amount of time in seconds before an access token expires"
  default     = null
}

variable "client_offline_session_idle_timeout" {
  type        = number
  description = "Time a client offline session is allowed to be idle"
  default     = null
}

variable "client_offline_session_max_lifespan" {
  type        = number
  description = "Max time before a client offline session is expired"
  default     = null
}

variable "client_session_idle_timeout" {
  type        = number
  description = "Time a client session is allowed to be idle"
  default     = null
}

variable "client_session_max_lifespan" {
  type        = number
  description = "Max time before a client session is expired"
  default     = null
}

variable "consent_required" {
  type        = bool
  description = "Users have to consent to client access"
  default     = false
}

variable "login_theme" {
  type        = string
  description = "Client login theme"
  default     = null
}

variable "exclude_session_state_from_auth_response" {
  type        = bool
  description = "Parameter session_state will not be included in OpenID Connect Authentication Response"
  default     = false
}

variable "use_refresh_tokens" {
  type        = string
  description = "A refresh_token will be created and added to the token response"
  default     = true
}

variable "backchannel_logout_url" {
  type        = string
  description = "URL that will cause the client to log itself out"
  default     = null
}

variable "backchannel_logout_session_required" {
  type        = bool
  description = "A sid (session ID) claim will be included in the logout token"
  default     = true
}

variable "backchannel_logout_revoke_offline_sessions" {
  type        = bool
  description = "Specifying whether a revoke_offline_access event is included in the Logout Token"
  default     = false
}

variable "client_role_protocol_mappers" {
  type        = list(any)
  description = "User client role protocol mappers"
  default     = []
}

variable "user_property_protocol_mappers" {
  type        = list(any)
  description = "User property protocol mappers"
  default     = []
}

variable "full_name_protocol_mapper" {
  type        = map(any)
  description = "User full name protocol mappers"
  default     = null
}

variable "audience_protocol_mappers" {
  type        = list(any)
  description = "Audience name protocol mappers"
  default     = []
}

variable "keys_filter_algorithm" {
  type        = list(string)
  description = "Keys will be filtered by algorithm"
  default     = []
}

variable "keys_filter_status" {
  type        = list(string)
  description = "Keys will be filtered by status"
  default     = ["ACTIVE"]
}
