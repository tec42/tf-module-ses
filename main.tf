terraform {
  required_version = ">= 1.7.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Verify email identity (domain or email address)
resource "aws_ses_email_identity" "identity" {
  for_each = toset(var.email_identities)

  email = each.value
}

# Configure DKIM for verified identities
resource "aws_ses_domain_dkim" "dkim" {
  for_each = toset([
    for email in var.email_identities : 
    split("@", email)[1] if length(split("@", email)) > 1
  ])

  domain = each.value
}

# Create configuration set for tracking
resource "aws_ses_configuration_set" "main" {
  name = "${var.service_name}-${var.environment}"

  reputation_metrics_enabled = true
  sending_enabled           = true
}

# Event destination for tracking (optional)
resource "aws_ses_event_destination" "cloudwatch" {
  count = var.enable_event_tracking ? 1 : 0

  name                   = "${var.service_name}-cloudwatch"
  configuration_set_name = aws_ses_configuration_set.main.name
  enabled                = true
  matching_types = [
    "send",
    "reject",
    "bounce",
    "complaint",
    "delivery",
    "open",
    "click"
  ]

  cloudwatch_destination {
    default_value  = "default"
    dimension_name = "ses:configuration-set"
    value_source   = "messageTag"
  }
}

# Receipt rule set (for receiving emails)
resource "aws_ses_receipt_rule_set" "main" {
  count = var.enable_email_receiving ? 1 : 0

  rule_set_name = "${var.service_name}-${var.environment}"
}

# Activate receipt rule set
resource "aws_ses_active_receipt_rule_set" "main" {
  count = var.enable_email_receiving ? 1 : 0

  rule_set_name = aws_ses_receipt_rule_set.main[0].rule_set_name
}
