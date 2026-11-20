# Deploy a Sovereign View with Bicep: 2026-10-31-preview

Use the [versioned Bicep package](/bicep/2026-10-31-preview) to deploy
`Microsoft.Sovereign/sovereignViews@2026-10-31-preview`. This API associates
existing policy-assignment IDs with the view. For the older service-created
assignment-parameter workflow, use the
[2026-03-15-preview guide](./deploy-sovereign-view-with-bicep-2026-03-15-preview.md).
Do not mix template, helper or parameter files between API-version packages.

For product availability, onboarding and access requirements, see the
[Sovereign Control Panel documentation](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/sovereign-control-panel).
The package targets the
[published API contract](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sovereign/resource-manager/Microsoft.Sovereign/Sovereign/preview/2026-10-31-preview/sovereign.json);
compilation alone does not prove deployed service compatibility.

> [!CAUTION]
> Use dedicated policy assignments for disposable views. View DELETE and
> failed-CREATE cleanup can remove supplied assignment references. An ID
> appearing as a reference in Bicep does not guarantee service cleanup will
> preserve the assignment. Keep ownership records and do not share one set of
> assignments across independently deleted views.

## 1. Get the matching package

Use PowerShell 7.2 or later, Azure CLI, Bicep and an approved login. Download
these five files from [`bicep/2026-10-31-preview/`](/bicep/2026-10-31-preview):

```text
main.bicep
example.bicepparam
register-scopes.ps1
create-policy-assignments.ps1
policy-overrides.example.json
```

Alternatively:

```powershell
git clone https://github.com/Azure/sovereign-control-panel-private-preview.git
Set-Location ".\sovereign-control-panel-private-preview\bicep\2026-10-31-preview"
az --version
az bicep version
```

If Bicep is missing, run `az bicep install`. Do not copy the legacy role modules
into this package. The template creates only the view with SystemAssigned
identity; the optional policy helper creates policy assignments separately.
It creates no role grants, policy definitions or policy-assignment identities.

## 2. Verify tenant, subscription and Sweden Central readiness

Use an existing approved context. These checks do not log in, select another
account or change the cloud:

```powershell
$expectedTenantId = "<APPROVED-TENANT-ID>"
$deploymentSubscriptionId = "<DEPLOYMENT-SUBSCRIPTION-ID>"
$resourceGroupName = "<EXISTING-RESOURCE-GROUP-NAME>"
$apiVersion = "2026-10-31-preview"

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
if ($LASTEXITCODE -ne 0) { throw "Provider readiness could not be read." }
```

Confirm Sweden Central, the selected API and identity support are advertised.
This package permits only `swedencentral`, the supported production deployment
region. The owner resource group can be in another region; use an existing
approved group or obtain approval before creating one.

Data Residency allowed locations are separate evaluation inputs, not inferred
from the view's region. The API version is a literal in the Bicep resource
declaration, not a runtime Bicep parameter.

## 3. Register scopes and confirm permissions

Run registration only when required and authorized:

```powershell
.\register-scopes.ps1 `
  -SubscriptionIds '<APPROVED-SUBSCRIPTION-ID>' `
  -ManagementGroupIds '<APPROVED-MANAGEMENT-GROUP-ID>'
```

Omit an unused scope argument. Management-group registration is asynchronous
and does not register subscriptions within that group. Confirm registration
and any applicable product eligibility requirements before continuing.

The deployment identity needs resource deployment/write access to the owner
RG. The optional helper also requires
`Microsoft.Authorization/policyAssignments/write` at every evaluation scope,
for example through Resource Policy Contributor. It does not grant itself
permissions. Separate identity-role changes require the appropriate Owner or
User Access Administrator permissions and approval.

## 4. Select dimensions and create policy assignments

Skip this step if supplying dedicated existing assignments manually in step 5.
The helper restores dimension selection and legacy-style parameter
customization while keeping `assignmentParameters` out of the view CREATE.

```powershell
$policySetup = @{
  ExpectedTenantId = $expectedTenantId
  SovereignViewName = "contoso-production-view"
  SubscriptionIds = @("<APPROVED-SUBSCRIPTION-ID>")
  # ManagementGroupIds = @("<APPROVED-MANAGEMENT-GROUP-ID>")
  Dimensions = @("DataResidency", "EncryptionAtRest", "ControlledNetworkExposure", "BusinessContinuity")
  AllowedLocations = @("<APPROVED-AZURE-REGION>")
  OutputDirectory = ".\generated-production"
}

.\create-policy-assignments.ps1 @policySetup -WhatIf
# Run only after approving the resolved scopes, definitions and parameter values.
.\create-policy-assignments.ps1 @policySetup -Confirm
$parameterFile = ".\generated-production\view.parameters.json"
```

The helper uses each initiative's own non-null parameter defaultValue, as in
the portal. It does not invent regions or replace default effects with Audit.
A parameter without a default must be provided; DR/R360 currently need
approved allowed locations. The shared `AllowedLocations` input keeps both
initiatives and the view's evaluation settings consistent.

DataResidency is selected by default and must remain selected. Residency360
creates both DR and R360 assignments. Use
`-ResourceEvaluationScope ResourceOnly` to omit R360.
ControlledNetworkExposure selects both network initiatives.
Each initiative receives one new assignment **at each selected scope**.
The helper resolves scope display names and verifies tenant membership;
subscription IDs are GUIDs, and MG IDs may be bare or full resource IDs.

Assignments default to `DoNotEnforce`, independently of effect parameters.
For example, an initiative may retain effect Deny without the assignment
enforcing it. Explicitly choosing `-EnforcementMode Default` can enforce those
defaults; review them before changing this option.

EncryptionInTransit is excluded from this helper. Effective
DeployIfNotExists/Modify effect parameters fail during planning because the
helper creates no assignment identity. Supply an explicit supported
non-remediating override or manage such assignments separately; the helper
never silently disables a policy's defaults.

### Customize initiative parameters and versions

Copy `policy-overrides.example.json` and pass `-OverridesPath` to replace
individual defaults using the familiar ARM value wrappers:

```powershell
$policySetup.OverridesPath = ".\policy-overrides.example.json"
.\create-policy-assignments.ps1 @policySetup -WhatIf
```

The example selects Audit and disables an EAR deny-only effect. Unspecified
parameters retain their initiative defaults. An override may also provide a
concrete `policyVersion` or the management-group/subscription form of the same
supported initiative ID. Unknown, unselected, duplicate or invalid parameters
are rejected before any assignment is created.

The helper reads defaults from the selected version, emits the concrete
version for the view and a minor wildcard for the assignment's
definitionVersion. Confirm service compatibility before pinning an older
minor version. If overriding listOfAllowedLocations per initiative, remove
the shared AllowedLocations argument and provide matching DR/R360 values.

### Generated handoff and failure safety

| File | Purpose |
| --- | --- |
| `view.parameters.json` | Complete native Bicep inputs, including scope labels, settings and actual created assignment IDs. |
| `view-properties.json` | REST CREATE properties using those same IDs; add location, approved tags and public SystemAssigned identity separately. |
| `manifest.json` | Exact planned/created IDs, effective values, ownership marker and progress. |

Review the generated JSON. The default view location is swedencentral;
`-IsWorkload:$false` selects a non-workload view. Keep generated files outside
source control.

WhatIf reads metadata and returns a plan without creating files/assignments.
The real run plans fresh unique IDs; do not use preview IDs for deployment.
Existing output directories or assignment-name collisions are not overwritten.
Each real run creates a new set, so keep its manifest instead of rerunning
creation merely to retrieve IDs.

On request/verification failure, the helper stops without automatic rollback.
Inspect manifest entries marked Creating because the remote PUT may have
succeeded. Deploy-ready files are written only after all creations are verified.

## 5. Alternative: supply existing assignments manually

If the helper generated your parameter JSON, skip to step 6. Otherwise:

```powershell
Copy-Item ".\example.bicepparam" ".\production.bicepparam"
$parameterFile = ".\production.bicepparam"
```

Replace every placeholder, set location to `swedencentral`, include approved
subscription/MG scope IDs **and display names**, and retain only selected
initiative blocks. The API schema allows optional labels, but including them
is necessary for compatibility with the current service validation.

Each initiative must contain `policyInitiativeId`, the concrete
`policyVersion`, its `dimension`, and matching existing `policyAssignmentIds`.
Do not add the older assignmentParameters field to this view's request.
The manual BC example has placeholders; use approved definition/version/IDs
or remove that optional block.

The settings object's default is Residency360, sample locations
northeurope/swedencentral and isWorkload=true. Those locations are examples,
not customer approval. Supplying settings replaces the whole default object:
omitted/null members are excluded, `{}` omits both properties, and false is
retained. When selecting ResourceOnly, remove the R360 initiative block and
make the view's allowed locations agree with its DR assignment.

## 6. Compile, validate and preview

```powershell
if (Select-String -Path $parameterFile -Pattern '<REQUIRED:|<APPROVED-') {
  throw "Replace all placeholders before deployment."
}
az bicep build --file ".\main.bicep" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Bicep compilation failed." }
if ($parameterFile.EndsWith(".bicepparam")) {
  az bicep build-params --file $parameterFile --stdout | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Parameter compilation failed." }
}

az deployment group validate `
  --name "sovereign-view-validation" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile
if ($LASTEXITCODE -ne 0) { throw "Validation failed; do not deploy." }

az deployment group what-if `
  --name "sovereign-view-preview" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile
if ($LASTEXITCODE -ne 0) { throw "What-If failed; do not deploy." }
```

Review only the intended view change: the template declares no policy/role
assignment resources. What-If does not fully describe service orchestration,
rollback or deletion behavior. Validation success alone does not prove the
service will accept every input. For preflight or authentication errors,
retain operation/correlation details and stop rather than disabling controls,
switching tenants or adding legacy fields.

## 7. Deploy once and verify

After preview approval:

```powershell
az deployment group create `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile
if ($LASTEXITCODE -ne 0) { throw "Deployment failed; inspect before retrying." }

$viewId = az deployment group show `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --query properties.outputs.sovereignViewId.value --output tsv
if ($LASTEXITCODE -ne 0 -or -not $viewId) { throw "View output could not be read." }

az resource show --ids $viewId --api-version $apiVersion `
  --query "{Id:id, Location:location, Status:properties.provisioningState, Scope:properties.scope, Policies:properties.policyInitiatives, Settings:properties.dimensionSettings, IsWorkload:properties.isWorkload, Identity:identity}" `
  --output json
if ($LASTEXITCODE -ne 0) { throw "View read-back failed." }
```

Confirm provisioning, identity, scope, policy IDs and evaluation settings.
Check operational status and permissions for every scope in the portal.
Service-side role orchestration can occur; this package does not declare or
run explicit role provisioning. Investigate missing access using the product's
supported recovery workflow.

Generating/Processing responses are expected while reports are being built.
They do not prove a completed snapshot exists. An Unknown permission check
is indeterminate, not proof a grant is absent; inspect its details and the
actual grants. A successful CREATE/GET likewise does not prove every later
read or update will succeed.

## 8. Review lifecycle and cleanup

Use only owned disposable fixtures for tests. View DELETE can remove supplied
policy IDs even though Bicep does not own those policy resources; failed
creation may also leave or remove associated resources. Check exact state
before cleanup. Never delete shared customer assignments because they appeared
in a view.

Keep the manifest and verify the view and intended fixtures are absent after
DELETE. Service-created RBAC may remain and require separate approved cleanup
for the exact view identity. For current reporting/onboarding procedures,
see the [product documentation](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/sovereign-control-panel).
