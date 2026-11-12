targetScope = 'resourceGroup'

type scopeItem = {
  id: string
  name: string?
}

@sealed()
type policyInitiative = {
  policyInitiativeId: string
  dimension: string
  policyVersion: string
  policyAssignmentIds: string[]
}

type dataResidencySettings = {
  resourceEvaluationScope: string
  parameters: {
    allowedLocations: string[]
  }
}

type dimensionSettingsConfiguration = {
  dataResidency: dataResidencySettings?
}

@sealed()
type viewSettings = {
  dimensionSettings: dimensionSettingsConfiguration?
  isWorkload: bool?
}

@description('Name of the Sovereign View resource.')
param sovereignViewName string

@description('Azure region where the Sovereign View resource is created. Confirm provider availability before deployment.')
@allowed([
  'swedencentral'
])
param location string

@description('Subscriptions evaluated by the view. Each item requires a subscription id; name is an optional display label.')
param scopeSubscriptions scopeItem[] = []

@description('Management groups evaluated by the view. Each item requires a full resource id; name is an optional display label.')
param scopeManagementGroups scopeItem[] = []

@description('Policy initiatives evaluated by the view, with the resource IDs of their existing policy assignments.')
param policyInitiatives policyInitiative[]

@description('Optional creation settings. Supplying this object replaces its defaults; omitted or null entries are excluded from the resource. The default locations are examples, not customer approval.')
param settings viewSettings = {
  dimensionSettings: {
    dataResidency: {
      resourceEvaluationScope: 'Residency360'
      parameters: {
        allowedLocations: [
          'northeurope'
          'swedencentral'
        ]
      }
    }
  }
  isWorkload: true
}

@description('Tags applied to the Sovereign View resource.')
param tags object = {}

var sovereignViewProperties = union(
  {
    scope: {
      managementGroups: scopeManagementGroups
      subscriptions: scopeSubscriptions
    }
    policyInitiatives: policyInitiatives
  },
  settings.?dimensionSettings == null ? {} : { dimensionSettings: settings.?dimensionSettings },
  settings.?isWorkload == null ? {} : { isWorkload: settings.?isWorkload }
)

#disable-next-line BCP081
resource sovereignView 'Microsoft.Sovereign/sovereignViews@2026-10-31-preview' = {
  name: sovereignViewName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: sovereignViewProperties
  tags: tags
}

output sovereignViewId string = sovereignView.id
#disable-next-line BCP053
output principalId string = sovereignView.identity.principalId
