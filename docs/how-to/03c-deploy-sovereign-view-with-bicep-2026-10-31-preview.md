# Deploy a Sovereign View with Bicep: 2026-10-31-preview

Use this package to create a Sovereign View against the published
`2026-10-31-preview` API contract. For the older assignment-parameter workflow,
use the [legacy Bicep guide](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md).
The [version catalog](/docs/bicep/README.md) explains how packages are maintained.

> [!IMPORTANT]
> This package requires a service deployment that supports the
> [published creation contract](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sovereign/resource-manager/Microsoft.Sovereign/Sovereign/examples/2026-10-31-preview/SovereignViewOperations_Create.json),
> including existing `policyAssignmentIds`. Confirm that support before
> running What-If or deploying.

> [!CAUTION]
> For preliminary tests, use dedicated disposable policy assignments rather
> than shared assignments. Confirm the deployed service's ownership and cleanup
> behavior before associating customer policy assignments.

## What the package creates

The template creates one `Microsoft.Sovereign/sovereignViews` resource with a
system-assigned managed identity. Its properties select subscription and
management-group scopes, associate existing policy assignments with compliance
dimensions, and configure evaluation settings.

The template declares **no policy or role assignment resources**. The optional
`create-policy-assignments.ps1` helper creates the policy assignments first and
supplies their IDs to the template. There are no role-assignment scripts.
The service can perform its own identity and access orchestration; verify that
separately. The registration helper only registers `Microsoft.Sovereign`.

Preview evaluations are read-only and do not automatically remediate
resources. Existing policy assignments retain their own effects; this template
does not change them.

## Before you begin

Complete [roles and permissions](/docs/how-to/01-roles%20and%20permissions.md)
and [provider registration](/docs/how-to/02-register-resource-provider.md).
Collect the approved tenant, deployment subscription, existing resource group,
view name, scope IDs, and display labels. The published schema allows optional
labels; include them during initial testing and confirm deployed behavior before
omitting them.

The policy helper can resolve and generate the following inputs. If supplying
your own assignments, collect them for every selected initiative:

| Input | Requirement |
| --- | --- |
| `policyInitiativeId` | The full resource ID of the policy set definition. |
| `dimension` | The intended compliance dimension, such as `DataResidency` or `BusinessContinuity`. |
| `policyVersion` | An explicit version matching the selected initiative, existing assignments, and deployed service. Replace the version placeholders before use. |
| `policyAssignmentIds` | Full resource IDs of existing assignments corresponding to the initiative and intended scopes. |

Confirm approved Data Residency locations and the desired evaluation mode.
The helper resolves the built-in Business Continuity initiative when selected;
the manual Bicep example uses placeholders that must be replaced or removed.
Availability and preview eligibility must be confirmed for each dimension.

The deployment identity needs Contributor or Owner on the resource group.
Running the policy helper also requires
`Microsoft.Authorization/policyAssignments/write` at every selected scope
(for example, Resource Policy Contributor). The helper neither grants this
permission nor creates policy definitions or managed identities.
Provider registration and access to selected scopes require the permissions
described in the onboarding guide. Granting missing managed-identity roles
separately requires Owner or User Access Administrator on the relevant scopes.
Do not assume resource creation success guarantees the identity has access.

## 1. Download the versioned package

Download all five files from
[`docs/bicep/2026-10-31-preview`](/docs/bicep/2026-10-31-preview)
into one local folder:

```text
2026-10-31-preview\
  main.bicep
  example.bicepparam
  register-scopes.ps1
  create-policy-assignments.ps1
  policy-overrides.example.json
```

Open PowerShell in that folder:

```powershell
az --version
az bicep version
```

If Bicep is missing, run `az bicep install`. Do not copy role modules from the
legacy package.

## 2. Verify the deployment tenant, subscription, and Sweden Central readiness

Use an existing approved login. These commands do not change the active account
or cloud. This package uses the public ARM endpoint.

```powershell
$expectedTenantId = "<APPROVED-TENANT-ID>"
$deploymentSubscriptionId = "<DEPLOYMENT-SUBSCRIPTION-ID>"
$resourceGroupName = "<EXISTING-RESOURCE-GROUP-NAME>"
$apiVersion = "2026-10-31-preview"

$tenantId = az account show --subscription $deploymentSubscriptionId --query tenantId --output tsv
if ($LASTEXITCODE -ne 0 -or $tenantId -ne $expectedTenantId) {
  throw "Use the approved tenant context before continuing."
}

az rest --method get `
  --url "https://management.azure.com/subscriptions/$deploymentSubscriptionId/providers/Microsoft.Sovereign?api-version=2021-04-01" `
  --resource https://management.azure.com/ `
  --subscription $deploymentSubscriptionId `
  --query "resourceTypes[?resourceType=='sovereignViews'].{Locations:locations, ApiVersions:apiVersions, Capabilities:capabilities}" `
  --output json
if ($LASTEXITCODE -ne 0) { throw "Provider readiness could not be read." }
```

The supplied example selects `swedencentral`, the only supported production
deployment region. Confirm both Sweden Central and `2026-10-31-preview`
are advertised for the approved subscription. The template and policy helper
allow only `swedencentral`. SystemAssigned identity remains enabled.
Data Residency allowed locations are a separate evaluation setting and are not
limited to the region where the view is created.

The template pins `2026-10-31-preview` in its resource declaration. The
`$apiVersion` variable above is for CLI read-back commands, not a Bicep parameter.
Select a different package to select a different resource API version.

## 3. Register the provider on selected scopes

Follow the registration guide, then use the supplied helper for every selected
subscription and management group:

```powershell
.\register-scopes.ps1 `
  -SubscriptionIds '<SUBSCRIPTION-ID-1>','<SUBSCRIPTION-ID-2>' `
  -ManagementGroupIds '<MANAGEMENT-GROUP-ID>'
```

Run registration only when required and authorized. Omit a scope argument when
no items of that kind are selected. The helper uses explicit public ARM URLs,
stops on CLI errors, and bounds subscription-registration polling.
Management-group registration is asynchronous and does not recursively
register subscriptions.

## 4. Select dimensions and create policy assignments

Use PowerShell 7.2 or later. This restores the dimension-selection and
`assignmentParameters` customization experience without putting the older
field in the Sovereign View CREATE body.

The helper loads each selected initiative from ARM and uses its own parameter
`defaultValue`, just like the portal. It does **not** substitute audit effects
or invent allowed regions. A parameter with no default must be supplied;
for Data Residency this currently includes `listOfAllowedLocations`.
`-AllowedLocations` supplies the same approved values to DR and R360 and to
the view's evaluation settings.

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

# Read definitions/scopes and review resolved bodies; no assignments or files.
.\create-policy-assignments.ps1 @policySetup -WhatIf

# After approval, create dedicated assignments and write the handoff files.
.\create-policy-assignments.ps1 @policySetup -Confirm
$parameterFile = ".\generated-production\view.parameters.json"
```

The default dimension is DataResidency, which must remain selected. Residency360
is the default evaluation mode and creates both DR and R360 assignments.
`-ResourceEvaluationScope ResourceOnly` selects DR without R360.
ControlledNetworkExposure includes both network initiatives, as in the portal.
The helper creates one assignment per selected initiative **at each scope**.
It accepts subscription GUIDs and bare or full management-group IDs, resolves
their display labels, and verifies they belong to the approved tenant.

Assignments default to `DoNotEnforce`, independently of the policy's parameter
defaults. For example, an initiative may retain `effect: Deny` while its
assignment does not enforce it. Explicitly choosing `-EnforcementMode Default`
can enforce those defaults: review the complete plan before changing this.
The helper creates no role grants and never changes the active account.
EncryptionInTransit is not included in this helper. Effective
DeployIfNotExists/Modify effects require policy-assignment identity even with
DoNotEnforce; the helper stops during planning if a selected initiative's effect
parameter needs identity. It never silently disables that parameter. Supply
an explicit supported non-remediating override or manage such assignments
separately.

### Customize parameters or initiative versions

Copy `policy-overrides.example.json` and pass `-OverridesPath` to replace
individual defaults using the familiar ARM `{ "value": ... }` wrappers.
Unspecified values retain their definition defaults. For example, the supplied
EAR override selects Audit and disables its deny-only effect.

```powershell
$policySetup.OverridesPath = ".\policy-overrides.example.json"
.\create-policy-assignments.ps1 @policySetup -WhatIf
```

Use a new output directory when actually creating another set. An override may
also specify an explicit `policyVersion` or the management-group/subscription
form of the same approved initiative ID. Only selected, supported initiatives
and known parameter names/types/allowed values are accepted. Defaults are read
from the requested version; the assignment uses its minor wildcard version,
while the view receives the concrete version. Confirm deployed-service support
before selecting an older minor version.

If configuring `listOfAllowedLocations` through overrides instead of the
shared switch, remove `AllowedLocations` from the splat and supply it for both
DR and R360. Their effective locations must agree. Required values, duplicate
scopes, malformed overrides and assignment-name collisions fail before any
assignment is created.

### Use the generated IDs with Bicep or REST

| Generated file | Use |
| --- | --- |
| `view.parameters.json` | Complete parameters for this package's `main.bicep`, including resolved scope labels, settings and `policyInitiatives`. |
| `view-properties.json` | The `properties` object for the REST CREATE body; add the view location, approved tags and public SystemAssigned identity separately. |
| `manifest.json` | Exact created IDs, effective parameter values, ownership marker and progress for review or cleanup. |

The assignment IDs in both handoff files are the **same IDs actually created**
by the helper. No policy/role resource is added to the Sovereign View template.
Review the generated JSON before continuing. The deployment location is
`swedencentral`; use `-IsWorkload:$false` when needed. Data Residency locations
are not inferred from the view's location. Keep generated files in your environment
folder, not in source control.

The helper never overwrites an existing output directory or updates an existing
assignment. It uses unique names compatible with management-group limits.
On an API or verification failure it stops, retains `manifest.json`, and does
not automatically delete assignments. A record marked Creating may have
succeeded remotely; inspect its exact ID. Deploy-ready files are produced only
after all creations are verified. Each new run creates a separate set, so keep
the manifest and do not rerun creation merely to retrieve IDs.

### Alternative: supply existing assignments manually

If you already have dedicated assignments, continue with the original
parameter-file editing experience instead of running the helper:

```powershell
Copy-Item ".\example.bicepparam" ".\production.bicepparam"
$parameterFile = ".\production.bicepparam"
```

Replace all required placeholders. Set the view name, deployment location,
scopes, approved tags, and the existing assignment IDs for every selected
initiative. Include display labels during preliminary testing; the published
schema allows omission, but deployed compatibility must be checked. Use `[]`
for a scope type not selected. The example includes DR and R360 associations for Residency360;
remove the R360 block when choosing ResourceOnly and verify the corresponding
service prerequisites.

Keep the optional dimension blocks the customer selected and delete the others.
Business Continuity is an initiative entry with
`dimension: 'BusinessContinuity'`, not a
`dimensionSettings.businessContinuity` property. Adding it to the parameter file
does not provision a policy initiative or its assignments.

### Evaluation settings and defaults

| Setting | Template default |
| --- | --- |
| `settings.dimensionSettings` | Data Residency `Residency360` with sample allowed locations `northeurope` and `swedencentral`. |
| `settings.isWorkload` | `true`. |

These fields are grouped in the typed `settings` parameter. Its default object
applies when that parameter is not supplied. Supplying `settings` replaces the
entire default object: include each field you intend to send. Omitted fields
and fields set to `null` are excluded from the resource body.

The default locations are **examples, not customer approval**. The parameter
example requires their replacement with approved locations:

```bicep
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
}
```

`Residency360` evaluates resources together with linked resources;
`ResourceOnly` evaluates the resource itself. Confirm the selected mode,
associated policies, and matching allowed-location settings are supported by
the service deployment before use.

Set `isWorkload` to `false` for a view that is not considered a workload.

For example, `param settings = {}` omits both optional properties.
Setting a field to `null` has the same omission behavior; `false` is not treated
as omission. Grouping the fields allows both default values and per-field
omission without unsupported non-null defaults on nullable Bicep parameters.

## 5. Compile and preview

Check for unresolved placeholders, then compile:

```powershell
if (Select-String -Path $parameterFile -Pattern '<REQUIRED:') {
  throw "Replace all required placeholders before deployment."
}

az bicep build --file ".\main.bicep" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Bicep compilation failed." }
if ($parameterFile.EndsWith(".bicepparam")) {
  az bicep build-params --file $parameterFile --stdout | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Bicep parameter compilation failed." }
}
```

Before What-If or creation, run provider validation:

```powershell
az deployment group validate `
  --name "sovereign-view-validation" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile
if ($LASTEXITCODE -ne 0) { throw "Provider validation failed; do not deploy." }
```

Advertised API versions and successful compilation are not a successful live
test. If validation reports `TemplateDeploymentValidationFailed`, retain the
tracking ID and investigate with the service owner. A `BearerFallbackDisabled`
response indicates a service authentication-path failure, not a reason to
disable authentication controls or remove valid resource properties. Stop and
collect correlation evidence; do not add legacy fields as a workaround.

After service compatibility and validation are confirmed, preview the changes:

```powershell
az deployment group what-if `
  --name "sovereign-view-preview" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile
if ($LASTEXITCODE -ne 0) { throw "What-If failed; do not deploy." }
```

Review the view name, region, scopes, existing assignment associations, optional
dimensions, and evaluation settings. The template should propose no role or
policy assignment resources and no unexpected deletions. These are template
changes, not a complete preview of service-side orchestration or rollback.
Investigate any service validation errors rather than bypassing the published
contract.

## 6. Deploy and verify

Run deployment only after the customer or deployment approver accepts the
preview:

```powershell
az deployment group create `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters $parameterFile `
  --output table
if ($LASTEXITCODE -ne 0) { throw "Deployment failed; inspect the operation before retrying." }

$viewId = az deployment group show `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --query properties.outputs.sovereignViewId.value `
  --output tsv
if ($LASTEXITCODE -ne 0 -or -not $viewId) { throw "Deployment output could not be read." }

az resource show `
  --ids $viewId `
  --api-version $apiVersion `
  --query "{Name:name, Location:location, Status:properties.provisioningState, Scope:properties.scope, Policies:properties.policyInitiatives, DimensionSettings:properties.dimensionSettings, IsWorkload:properties.isWorkload}" `
  --output json
if ($LASTEXITCODE -ne 0) { throw "Resource read-back failed." }
```

Confirm creation succeeded and the returned properties match the approved
configuration. Open the view's **Properties** page and check permission and
operational status for every scope. If access is missing, use the
[managed-identity permission recovery guide](/docs/how-to/04-assign-managed-identity-roles.md).
No role-provisioning script is needed as a normal step of this package.

Continue with [the compliance report](/docs/how-to/05-view-compliance-report.md)
only after required access is present. For errors, see
[troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md).
