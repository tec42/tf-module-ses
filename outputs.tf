output "verified_email_identities" {
  description = "List of verified email identities"
  value       = [for identity in aws_ses_email_identity.identity : identity.email]
}

output "configuration_set_name" {
  description = "Name of the SES configuration set"
  value       = aws_ses_configuration_set.main.name
}

output "configuration_set_arn" {
  description = "ARN of the SES configuration set"
  value       = aws_ses_configuration_set.main.arn
}

output "dkim_tokens" {
  description = "DKIM tokens for domain verification (map of domain to tokens)"
  value = {
    for domain, dkim in aws_ses_domain_dkim.dkim :
    domain => dkim.dkim_tokens
  }
}

output "receipt_rule_set_name" {
  description = "Name of the receipt rule set (if enabled)"
  value       = var.enable_email_receiving ? aws_ses_receipt_rule_set.main[0].rule_set_name : null
}

output "send_email_policy_arn" {
  description = "ARN of the managed IAM policy for ses:SendEmail and ses:SendRawEmail (null if create_send_policy = false)"
  value       = var.create_send_policy ? aws_iam_policy.send_email[0].arn : null
}
