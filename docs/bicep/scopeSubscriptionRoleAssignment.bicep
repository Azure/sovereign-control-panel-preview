targetScope = 'subscription'

@description('Object ID of the Sovereign View system-assigned managed identity.')
param principalId string

@description('Built-in role definition IDs assigned on this subscription.')
param roleDefinitionIds array = [
  'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
]

resource roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in roleDefinitionIds: {
    name: guid(subscription().id, principalId, roleDefinitionId)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
      principalId: principalId
      principalType: 'ServicePrincipal'
    }
  }
]