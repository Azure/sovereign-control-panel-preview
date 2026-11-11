using './main.bicep'

// Copy this file for the test environment and replace all required
// placeholders. Do not deploy this example unchanged.

param sovereignViewName = '<REQUIRED: SOVEREIGN-VIEW-NAME>'

// Confirm Private.RegEnvDev2608/sovereignViews reports Denmark East for the
// test subscription before deployment.
param location = 'denmarkeast'

// Add every approved subscription. Use [] for a management-group-only view.
param scopeSubscriptions = [
  {
    id: '<REQUIRED: SUBSCRIPTION-ID>'
    name: '<REQUIRED: SUBSCRIPTION-DISPLAY-NAME>'
  }
]

// Add approved management groups using full resource IDs. Leave [] when none
// are selected. Supply display names for compatibility with the private service.
param scopeManagementGroups = [
  // {
  //   id: '/providers/Microsoft.Management/managementGroups/<MANAGEMENT-GROUP-ID>'
  //   name: '<MANAGEMENT-GROUP-DISPLAY-NAME>'
  // }
]

// Use dedicated test assignments, not shared assignments: the private service
// can delete referenced assignments on view deletion or failed creation.
// Confirm each version against the assignment and the private service.
param policyInitiatives = [
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/bebfcba2-e789-4da6-9043-726ef3a00d02'
    policyVersion: '<REQUIRED: DATA-RESIDENCY-POLICY-VERSION>'
    dimension: 'DataResidency'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-DATA-RESIDENCY-POLICY-ASSIGNMENT-ID>'
    ]
  }

  // Residency360 also evaluates the R360 initiative. Delete this block when
  // using ResourceOnly. Supply the definition and assignments for the test environment.
  {
    policyInitiativeId: '<REQUIRED: DATA-RESIDENCY-R360-POLICY-INITIATIVE-ID>'
    policyVersion: '<REQUIRED: DATA-RESIDENCY-R360-POLICY-VERSION>'
    dimension: 'DataResidency'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-DATA-RESIDENCY-R360-POLICY-ASSIGNMENT-ID>'
    ]
  }

  // OPTIONAL: Encryption at Rest. Delete this block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/f15f4d95-c59c-4395-9317-be6978d0743f'
    policyVersion: '<REQUIRED: ENCRYPTION-AT-REST-POLICY-VERSION>'
    dimension: 'EncryptionAtRest'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-ENCRYPTION-AT-REST-POLICY-ASSIGNMENT-ID>'
    ]
  }

  // OPTIONAL: Controlled Network Exposure - Private Endpoints. Delete this
  // block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/b71f6054-d890-4c78-b809-2ae9dc6a0cfc'
    policyVersion: '<REQUIRED: PRIVATE-ENDPOINTS-POLICY-VERSION>'
    dimension: 'ControlledNetworkExposure'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-PRIVATE-ENDPOINTS-POLICY-ASSIGNMENT-ID>'
    ]
  }

  // OPTIONAL: Controlled Network Exposure - Limit Public Network Access.
  // Delete this block when not selected.
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/a3d07baa-2640-4810-9814-c8c4bbfc21a6'
    policyVersion: '<REQUIRED: PUBLIC-NETWORK-ACCESS-POLICY-VERSION>'
    dimension: 'ControlledNetworkExposure'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-PUBLIC-NETWORK-ACCESS-POLICY-ASSIGNMENT-ID>'
    ]
  }

  // OPTIONAL: Business Continuity. Delete this block when not selected.
  // Replace the dummy initiative ID and version with approved values.
  {
    policyInitiativeId: '<REQUIRED: BUSINESS-CONTINUITY-POLICY-INITIATIVE-ID>'
    policyVersion: '<REQUIRED: BUSINESS-CONTINUITY-POLICY-VERSION>'
    dimension: 'BusinessContinuity'
    policyAssignmentIds: [
      '<REQUIRED: EXISTING-BUSINESS-CONTINUITY-POLICY-ASSIGNMENT-ID>'
    ]
  }
]

param settings = {
  dimensionSettings: {
    dataResidency: {
      resourceEvaluationScope: 'Residency360'
      parameters: {
        allowedLocations: [
          '<REQUIRED: APPROVED-AZURE-REGION>'
        ]
      }
    }
  }
  isWorkload: true
  regulatoryDocumentName: 'SovereignControlBaseline'
}

param tags = {
  environment: '<REQUIRED: ENVIRONMENT>'
  owner: '<REQUIRED: TEAM-OR-EMAIL>'
}
