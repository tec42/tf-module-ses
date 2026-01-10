variable "service_name" {
  description = "Name of the service (e.g., 'identity', 'cook')"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.service_name))
    error_message = "Service name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Environment must be one of: development, staging, production."
  }
}

variable "email_identities" {
  description = "List of email addresses or domains to verify for sending"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for email in var.email_identities :
      can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "All email identities must be valid email addresses."
  }
}

variable "enable_event_tracking" {
  description = "Enable CloudWatch event tracking for emails"
  type        = bool
  default     = false
}

variable "enable_email_receiving" {
  description = "Enable email receiving capabilities"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
