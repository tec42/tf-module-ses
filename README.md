# AWS SES Terraform Module

This module provisions and configures AWS Simple Email Service (SES) for sending transactional emails.

## Features

- ✅ Email identity verification
- ✅ DKIM configuration for domains
- ✅ Configuration sets for tracking
- ✅ CloudWatch event destinations (optional)
- ✅ Email receiving capabilities (optional)
- ✅ Works with LocalStack for development
- ✅ DRY tagging with locals pattern

## Usage

### Basic Example

```hcl
module "ses" {
  source = "../../terraform-modules/ses"

  service_name = "identity"
  environment  = "development"

  email_identities = [
    "noreply@yourdomain.com"
  ]

  enable_event_tracking = false
  enable_email_receiving = false

  tags = {
    Project = "Identity Service"
    Team    = "Platform"
  }
}
```

### Production Example with Tracking

```hcl
module "ses" {
  source = "../../terraform-modules/ses"

  service_name = "identity"
  environment  = "production"

  email_identities = [
    "noreply@yourdomain.com",
    "support@yourdomain.com"
  ]

  enable_event_tracking = true
  enable_email_receiving = false

  tags = {
    Project = "Identity Service"
    Team    = "Platform"
  }
}
```

## LocalStack Configuration

For local development with LocalStack, use the following endpoints:

```bash
# SES endpoint
http://localstack:4566

# AWS CLI example to verify identity
aws --endpoint-url=http://localhost:4566 ses verify-email-identity \
  --email-address noreply@yourdomain.com

# List verified identities
aws --endpoint-url=http://localhost:4566 ses list-identities
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| service_name | Name of the service | string | n/a | yes |
| environment | Environment (development/staging/production) | string | "development" | no |
| email_identities | List of email addresses to verify | list(string) | [] | no |
| enable_event_tracking | Enable CloudWatch event tracking | bool | false | no |
| enable_email_receiving | Enable email receiving | bool | false | no |
| tags | Additional tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| verified_email_identities | List of verified email identities |
| configuration_set_name | Name of the SES configuration set |
| configuration_set_arn | ARN of the SES configuration set |
| dkim_tokens | DKIM tokens for domain verification |
| receipt_rule_set_name | Name of receipt rule set (if enabled) |

## Notes

- In LocalStack, email identities are automatically verified
- In AWS production, you need to verify identities via email confirmation
- DKIM tokens should be added as DNS TXT records for domain verification
- Configuration sets help track email delivery metrics

## Tagging Strategy

All resources automatically include:
- `Service`: Service name from variable
- `Environment`: Environment from variable
- `ManagedBy`: terraform
- Custom tags: Merged from `var.tags`

The module uses a locals pattern for consistent tagging across all resources.
