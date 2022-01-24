output "id" {
  description = "The ID of the Subscription Template Deployment"
  value       = "azurerm_subscription_template_deployment.main.id"
}

output "output_content" {
  description = "The JSON Content of the Outputs of the ARM Template"
  value       = "azurerm_subscription_template_deployment.main.output_content"
}
