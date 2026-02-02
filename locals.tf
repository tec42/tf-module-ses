# Local values for reusable configuration

locals {
  common_tags = merge(
    var.tags,
    {
      Service     = var.service_name
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
}
