using './main.bicep'

// Copy this file, rename it for the customer environment, and replace every
// <REQUIRED: ...> value. Do not deploy this example unchanged.

param sovereignViewName = '<REQUIRED: SOVEREIGN-VIEW-NAME>'

// Use a location returned for Microsoft.Sovereign/sovereignViews in the
// deployment subscription.
param location = 'swedencentral'

// Add every approved subscription. Use [] for a management-group-only view.
param scopeSubscriptions = [
  {
    id: '<REQUIRED: SUBSCRIPTION-ID>'
    name: '<REQUIRED: SUBSCRIPTION-DISPLAY-NAME>'
  }
]

// Add approved management groups using full resource IDs. Leave [] when none
// are selected.
param scopeManagementGroups = [
  // {
  //   id: '/providers/Microsoft.Management/managementGroups/<MANAGEMENT-GROUP-ID>'
  //   name: '<MANAGEMENT-GROUP-DISPLAY-NAME>'
  // }
]

param assignReaderToScopeSubscription = true
param assignResourcePolicyContributorToScopeSubscription = true

param policyInitiatives = [
  // REQUIRED: Data Residency.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/bebfcba2-e789-4da6-9043-726ef3a00d02'
    policyVersion: '1.0.0-preview'
    dimension: 'DataResidency'
    assignmentParameters: {
      effect: {
        value: 'Audit'
      }
      listOfAllowedLocations: {
        // Replace with the customer's approved Data Residency locations.
        value: [
          '<REQUIRED: APPROVED-AZURE-REGION>'
        ]
      }
    }
  }

  // OPTIONAL: Encryption at Rest. Delete this block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/f15f4d95-c59c-4395-9317-be6978d0743f'
    policyVersion: '2.0.0-preview'
    dimension: 'EncryptionAtRest'
    assignmentParameters: {
      effect: {
        value: 'Audit'
      }
      effect_audit: {
        value: 'Audit'
      }
      effect_auditIfNotExists: {
        value: 'AuditIfNotExists'
      }
      effect_deny: {
        value: 'Disabled'
      }
    }
  }

  // OPTIONAL: Controlled Network Exposure - Private Endpoints. Delete this
  // block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/b71f6054-d890-4c78-b809-2ae9dc6a0cfc'
    policyVersion: '1.0.0-preview'
    dimension: 'ControlledNetworkExposure'
    assignmentParameters: {
      effect_audit: {
        value: 'Audit'
      }
      effect_auditIfNotExists: {
        value: 'AuditIfNotExists'
      }
    }
  }

  // OPTIONAL: Controlled Network Exposure - Limit Public Network Access.
  // Delete this block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/a3d07baa-2640-4810-9814-c8c4bbfc21a6'
    policyVersion: '1.0.0-preview'
    dimension: 'ControlledNetworkExposure'
    assignmentParameters: {
      effect_audit: {
        value: 'Audit'
      }
      effect_deny: {
        value: 'Audit'
      }
    }
  }
]

param tags = {
  environment: '<REQUIRED: ENVIRONMENT>'
  owner: '<REQUIRED: TEAM-OR-EMAIL>'
}