targetScope = 'resourceGroup'

@description('Name of the Sovereign View resource.')
param sovereignViewName string

@description('Azure region where the Sovereign View resource is created.')
@allowed([
  // Add a region only after Microsoft.Sovereign/sovereignViews reports it for
  // the deployment subscription.
  'swedencentral'
  'uksouth'
])
param location string

@description('Subscriptions evaluated by the view. Each item requires id and name properties.')
param scopeSubscriptions array = []

@description('Management groups evaluated by the view. Each item requires a full resource id and name properties.')
param scopeManagementGroups array = []

@description('Policy initiatives evaluated by the view. Data Residency is required.')
param policyInitiatives array

@description('Tags applied to the Sovereign View resource.')
param tags object = {}

@description('Grant Reader to the view identity on each in-scope subscription. Required for report data collection.')
param assignReaderToScopeSubscription bool = true

@description('Grant Resource Policy Contributor on each in-scope subscription to accelerate the first evaluation.')
param assignResourcePolicyContributorToScopeSubscription bool = false

var readerRoleDefinitionId = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
var resourcePolicyContributorRoleDefinitionId = '36243c78-bf99-498c-9df9-86d9f8d28608'

var scopeRoleDefinitionIds = concat(
  assignReaderToScopeSubscription ? [readerRoleDefinitionId] : [],
  assignResourcePolicyContributorToScopeSubscription ? [resourcePolicyContributorRoleDefinitionId] : []
)

// Bicep requires an API version to be a compile-time literal. Review the new
// schema before changing this value when a later API version becomes available.
#disable-next-line BCP081
resource sovereignView 'Microsoft.Sovereign/sovereignViews@2026-03-15-preview' = {
  name: sovereignViewName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    scope: {
      managementGroups: [
        for managementGroup in scopeManagementGroups: {
          id: managementGroup.id
          name: managementGroup.name
        }
      ]
      subscriptions: [
        for subscriptionScope in scopeSubscriptions: {
          id: subscriptionScope.id
          name: subscriptionScope.name
        }
      ]
    }
    policyInitiatives: policyInitiatives
  }
  tags: tags
}

// A resource-group deployment can nest subscription-scoped deployments, so
// subscription roles are assigned automatically. Management-group roles use
// the separate scopeManagementGroupRoleAssignment.bicep deployment.
module subscriptionScopeRoles 'scopeSubscriptionRoleAssignment.bicep' = [
  for subscriptionScope in scopeSubscriptions: {
    name: 'svrole-sub-${uniqueString(sovereignViewName, subscriptionScope.id)}'
    scope: subscription(subscriptionScope.id)
    params: {
      #disable-next-line BCP053
      principalId: sovereignView.identity.principalId
      roleDefinitionIds: scopeRoleDefinitionIds
    }
  }
]

output sovereignViewId string = sovereignView.id
#disable-next-line BCP053
output principalId string = sovereignView.identity.principalId