# Azure Subscription Template Deployment

This module is just a thin wrapper around the `azurerm_subscription_template_deployment` resource.

## Usage

Example using [tau](https://github.com/avinor/tau) for deployment. It deploys
the Azure Resource Manager template referred from the tutorial [_Monitor
Azure AD B2C with Azure
Monitor_](https://docs.microsoft.com/en-us/azure/active-directory-b2c/azure-monitor).

```terraform
module {
  source = "github.com/avinor/terraform-azurerm-subscription-template-deployment"
}

inputs {

  name = "b2clogs-deployment"

  location = "westeurope"

  parameters_content = jsonencode({
    "mspOfferName": {
      value = "Azure AD B2C Monitoring"
    }
    "mspOfferDescription": {
      value = "Enable Azure AD B2C Monitoring"
    }
    "managedByTenantId" = {
      value = "11111111-1111-1111-1111-111111111111"
    }
    "authorizations" = {
      value = [{
            principalId = "11111111-1111-1111-1111-111111111111"
            principalIdDisplayName = "Azure AD B2C tenant administrators"
            roleDefinitionId = "b24988ac-6180-42a0-ab88-20f7382dd24c"
      }]
    }
    "rgName" = {
      value = "b2logs-dev"
    }
  })

  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "mspOfferName": {
            "type": "string",
            "metadata": {
                "description": "Specify a unique name for your offer"
            },
            "defaultValue": "<to be filled out by MSP> Specify a title for your offer"
        },
        "mspOfferDescription": {
            "type": "string",
            "metadata": {
                "description": "Name of the Managed Service Provider offering"
            },
            "defaultValue": "<to be filled out by MSP> Provide a brief description of your offer"
        },
        "managedByTenantId": {
            "type": "string",
            "metadata": {
                "description": "Specify the tenant id of the Managed Service Provider"
            },
            "defaultValue": "<to be filled out by MSP> Provide your tenant id"
        },
        "authorizations": {
            "type": "array",
            "metadata": {
                "description": "Specify an array of objects, containing tuples of Azure Active Directory principalId, a Azure roleDefinitionId, and an optional principalIdDisplayName. The roleDefinition specified is granted to the principalId in the provider's Active Directory and the principalIdDisplayName is visible to customers."
            },
            "defaultValue": [
                { 
                    "principalId": "<Replace with group's OBJECT ID>",
                    "principalIdDisplayName": "Azure AD B2C tenant administrators",
                    "roleDefinitionId": "b24988ac-6180-42a0-ab88-20f7382dd24c"
                }
            ]
        },
        "rgName": {
            "type": "string",
            "defaultValue": "<Replace with Resource Group's Name e.g. az-monitor-rg>"
        }              
    },
    "variables": {
        "mspRegistrationName": "[guid(parameters('mspOfferName'))]",
        "mspAssignmentName": "[guid(parameters('mspOfferName'))]"
    },
    "resources": [
        {
            "type": "Microsoft.ManagedServices/registrationDefinitions",
            "apiVersion": "2019-06-01",
            "name": "[variables('mspRegistrationName')]",
            "properties": {
                "registrationDefinitionName": "[parameters('mspOfferName')]",
                "description": "[parameters('mspOfferDescription')]",
                "managedByTenantId": "[parameters('managedByTenantId')]",
                "authorizations": "[parameters('authorizations')]"
            }
        },
        {
            "type": "Microsoft.Resources/deployments",
            "apiVersion": "2018-05-01",
            "name": "rgAssignment",
            "resourceGroup": "[parameters('rgName')]",
            "dependsOn": [
                "[resourceId('Microsoft.ManagedServices/registrationDefinitions/', variables('mspRegistrationName'))]"
            ],
            "properties":{
                "mode":"Incremental",
                "template":{
                    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
                    "contentVersion": "1.0.0.0",
                    "parameters": {},
                    "resources": [
                        {
                            "type": "Microsoft.ManagedServices/registrationAssignments",
                            "apiVersion": "2019-06-01",
                            "name": "[variables('mspAssignmentName')]",
                            "properties": {
                                "registrationDefinitionId": "[resourceId('Microsoft.ManagedServices/registrationDefinitions/', variables('mspRegistrationName'))]"
                            }
                        }
                    ]
                }
            }
        }
    ],
    "outputs": {
        "mspOfferName": {
            "type": "string",
            "value": "[concat('Managed by', ' ', parameters('mspOfferName'))]"
        },
        "authorizations": {
            "type": "array",
            "value": "[parameters('authorizations')]"
        }
    }
}
TEMPLATE

  // NOTE: whilst we show an inline template here, we recommend
  // sourcing this from a file for readability/editor support
}
```
