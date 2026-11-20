# Deploy a Sovereign View with Bicep: 2026-03-15-preview

Use the [legacy Bicep package](/bicep) to deploy
`Microsoft.Sovereign/sovereignViews@2026-03-15-preview`. This version accepts
`assignmentParameters`; the service creates the selected policy assignments.
For existing-assignment references and configurable evaluation settings, use
the [2026-10-31-preview guide](./deploy-sovereign-view-with-bicep-2026-10-31-preview.md).
Do not mix files or parameter shapes between versions.

For product eligibility, onboarding and access requirements, see the
[Sovereign Control Panel documentation](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/sovereign-control-panel).
The templates in this repository are reference materials, not a guarantee of
service availability for every tenant or subscription.

> [!CAUTION]
> Creation can assign policies at the selected scopes and grant the view's
> managed identity access. Review every scope, initiative and effect before
> deployment. Use isolated scopes for preliminary testing. Do not retry a
> failed deployment or delete a view until its policy and identity state have
> been checked.

## 1. Get the matching package

Use PowerShell, Azure CLI and Bicep. Download these five files from
[`bicep/`](/bicep) into the same local directory:

```text
main.bicep
example.bicepparam
register-scopes.ps1
scopeSubscriptionRoleAssignment.bicep
scopeManagementGroupRoleAssignment.bicep
```

Alternatively, clone the repository and open its `bicep` directory:

```powershell
git clone https://github.com/Azure/sovereign-control-panel-private-preview.git
Set-Location ".\sovereign-control-panel-private-preview\bicep"
az --version
az bicep version
```

If Bicep is missing, install it with `az bicep install`.

## 2. Verify context and Sweden Central availability

Use an existing approved Azure CLI login. Set the intended values below;
these checks do not change the active account or cloud.

```powershell
$expectedTenantId = "<APPROVED-TENANT-ID>"
$deploymentSubscriptionId = "<DEPLOYMENT-SUBSCRIPTION-ID>"
$resourceGroupName = "<EXISTING-RESOURCE-GROUP-NAME>"
$apiVersion = "2026-03-15-preview"

$tenantId = az account show --query tenantId --output tsv
if ($LASTEXITCODE -ne 0 -or $tenantId -ne $expectedTenantId) {
  throw "Use the approved tenant context before continuing."
}
$deploymentTenantId = az account show --subscription $deploymentSubscriptionId --query tenantId --output tsv
if ($LASTEXITCODE -ne 0 -or $deploymentTenantId -ne $expectedTenantId) {
  throw "The deployment subscription must belong to the approved tenant."
}

az rest --method get `
  --url "https://management.azure.com/subscriptions/$deploymentSubscriptionId/providers/Microsoft.Sovereign?api-version=2021-04-01" `
  --resource https://management.azure.com/ `
  --subscription $deploymentSubscriptionId `
  --query "resourceTypes[?resourceType=='sovereignViews'].{Locations:locations, ApiVersions:apiVersions, Capabilities:capabilities}" `
  --output json
if ($LASTEXITCODE -ne 0) { throw "Provider availability could not be read." }
```

Confirm Sweden Central and the selected API version are advertised.
The checked-in template permits only `swedencentral`. The resource group's
location can differ from the view's deployment region; use an existing approved
group, or obtain approval before creating one.

The view's **deployment region** and the policy's **allowed Data Residency
locations** are different settings. Do not infer approved evaluation locations
from the deployment region.

## 3. Register selected scopes and review permissions

Register the provider on each selected subscription and management group only
when required and authorized:

```powershell
.\register-scopes.ps1 `
  -SubscriptionIds '<APPROVED-SUBSCRIPTION-ID>' `
  -ManagementGroupIds '<APPROVED-MANAGEMENT-GROUP-ID>'
```

Omit an argument when selecting no scopes of that kind. Management-group
registration does not recursively register child subscriptions. Verify provider
registration and any product eligibility prerequisites before deployment.

The deployment identity needs resource deployment/write access to the owner
resource group and appropriate access to the selected scopes. Policy creation
requires policy-assignment write permission. Explicit role provisioning also
requires role-assignment write permission, such as Owner or User Access
Administrator at the relevant scope.

## 4. Set view, scope and initiative parameters

Keep the example as a reference and create an environment-specific copy:

```powershell
Copy-Item ".\example.bicepparam" ".\production.bicepparam"
```

Replace every `<REQUIRED: ...>` placeholder. Set the name, region and approved
scopes:

```bicep
param sovereignViewName = 'contoso-production-view'
param location = 'swedencentral'

param scopeSubscriptions = [
  {
    id: '00000000-0000-0000-0000-000000000000'
    name: 'Contoso Production'
  }
]

param scopeManagementGroups = []
```

Supply display names for all selected scopes. Management-group IDs must be full
resource IDs such as
`/providers/Microsoft.Management/managementGroups/contoso-production`.
Use subscriptions, management groups or both; do not enter individual resource
groups or resources as scopes.

Data Residency is required in this workflow. Set the customer's approved
`listOfAllowedLocations.value`, and retain only approved optional initiative
blocks. The example includes Encryption at Rest and both Controlled Network
Exposure initiatives. Review each initiative's current definition, version,
parameter schema and service compatibility instead of assuming example
version values remain current.

The legacy shape is:

```bicep
param policyInitiatives = [
  {
    policyInitiativeId: '/providers/Microsoft.Authorization/policySetDefinitions/bebfcba2-e789-4da6-9043-726ef3a00d02'
    policyVersion: '<VERIFIED-DATA-RESIDENCY-VERSION>'
    dimension: 'DataResidency'
    assignmentParameters: {
      effect: {
        value: 'Audit'
      }
      listOfAllowedLocations: {
        value: [
          '<APPROVED-AZURE-REGION>'
        ]
      }
    }
  }
]
```

The supplied effect choices are intended for assessment: Audit reports
findings, AuditIfNotExists checks related configuration, and Disabled turns
off the selected behavior. Do not replace them with enforcing or remediating
effects without explicit approval and the necessary identity/access setup.
This API's parameter-creation workflow is different from the new API's
existing `policyAssignmentIds` references.

### Managed-identity access

The legacy example enables both subscription-scoped role options:

```bicep
param assignReaderToScopeSubscription = true
param assignResourcePolicyContributorToScopeSubscription = true
```

Reader supports report collection. Resource Policy Contributor can support
evaluation operations. These flags create explicit role assignments on
selected subscriptions; turn them off only when the required access is
provided through an approved alternative. Service-side orchestration may also
grant access, so inspect existing grants rather than assuming they are missing.

The subscription flags do not deploy management-group roles. If separate MG
role provisioning is necessary and approved, use the included
`scopeManagementGroupRoleAssignment.bicep` with the created view identity.
Do not use these legacy role modules with the new API package.

## 5. Compile, validate and preview

```powershell
if (Select-String -Path ".\production.bicepparam" -Pattern '<REQUIRED:|<VERIFIED-|<APPROVED-') {
  throw "Replace all placeholders before deployment."
}
az bicep build --file ".\main.bicep" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Bicep compilation failed." }
az bicep build-params --file ".\production.bicepparam" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Parameter compilation failed." }

az deployment group validate `
  --name "sovereign-view-validation" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam"
if ($LASTEXITCODE -ne 0) { throw "Validation failed; do not deploy." }

az deployment group what-if `
  --name "sovereign-view-preview" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam"
if ($LASTEXITCODE -ne 0) { throw "What-If failed; do not deploy." }
```

Review the view, scopes and explicit subscription role changes. What-If
describes template resources, not every service-created policy or role.
Successful compilation or validation alone does not establish that actual
service creation will succeed.

## 6. Deploy once and verify

After approval of the preview:

```powershell
az deployment group create `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam"
if ($LASTEXITCODE -ne 0) { throw "Deployment failed; inspect before retrying." }

$viewId = az deployment group show `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --query properties.outputs.sovereignViewId.value --output tsv
if ($LASTEXITCODE -ne 0 -or -not $viewId) { throw "View output could not be read." }

az resource show --ids $viewId --api-version $apiVersion --output json
if ($LASTEXITCODE -ne 0) { throw "View read-back failed." }
```

Confirm provisioningState, scope, generated policy IDs and identity. Check
operational status and required permissions in the portal. A pending
Generating/Processing report is not a request error, but does not prove a
completed report exists. Do not invent evaluated resource IDs to test details.

If an older API list operation fails response-schema validation, retain its
error/correlation and distinguish that read failure from a successful
single-resource CREATE/GET. For deployment or authentication errors, inspect
the operation details before retrying; do not disable authentication controls
or change the tenant to work around an error.

## 7. Review cleanup before deleting

Record the created view, policy and identity/role IDs. Service DELETE or
failed-CREATE cleanup can remove policy assignments associated with the view.
Use dedicated assignments/scopes for disposable tests and never assume shared
references are preserved. Verify policy and role state after an asynchronous
deletion; residual RBAC grants may require separate, approved cleanup.

For ongoing onboarding and reporting guidance, use the
[current product documentation](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/sovereign-control-panel).
