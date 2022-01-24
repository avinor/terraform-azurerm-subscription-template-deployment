module "b2clogs" {

  source = "../../"

  tags = {
    tag1 = "value1"
  }

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

  template_content = file("${path.module}/rgDelegatedResourceManagement.json")
}
