# Deploy a Sovereign View with Bicep: 2026-10-31-preview

Use this package to create a Sovereign View against the published
`2026-10-31-preview` API contract. For the older assignment-parameter workflow,
use the [legacy Bicep guide](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md).
The [version catalog](/docs/bicep/README.md) explains how packages are maintained.

> [!IMPORTANT]
> Sovereign Control Panel is an invite-only **Private Preview**. Confirm that
> the customer tenant and intended subscriptions are approved before deployment.

> [!IMPORTANT]
> This package requires a service deployment that supports the
> [published creation contract](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sovereign/resource-manager/Microsoft.Sovereign/Sovereign/examples/2026-10-31-preview/SovereignViewOperations_Create.json),
> including existing `policyAssignmentIds`. Confirm that support before
> running What-If or deploying. Bicep compilation alone does not verify it.
> Do not add the older `assignmentParameters` field as a workaround.

> [!CAUTION]
> For preliminary tests, use dedicated disposable policy assignments rather
> than shared assignments. Confirm the deployed service's ownership and cleanup
> behavior before associating customer policy assignments. A reference in an
> ARM template is not a guarantee that service-side rollback or deletion will
> preserve the referenced assignment.

## What the package creates

The template creates one `Microsoft.Sovereign/sovereignViews` resource with a
system-assigned managed identity. Its properties select subscription and
management-group scopes, associate existing policy assignments with compliance
dimensions, and configure evaluation settings.

The template declares **no policy or role assignment resources** and includes
no role-assignment scripts. The service can perform its own identity and access
orchestration; verify that separately. The registration helper only registers
`Microsoft.Sovereign`.

Private Preview evaluations are read-only and do not automatically remediate
resources. Existing policy assignments retain their own effects; this template
does not change them.

## Before you begin

Complete [roles and permissions](/docs/how-to/01-roles%20and%20permissions.md)
and [provider registration](/docs/how-to/02-register-resource-provider.md).
Collect the approved tenant, deployment subscription, existing resource group,
view name, scope IDs, and display labels. The published schema allows optional
labels; include them during initial testing and confirm deployed behavior before
omitting them.

You also need the following for every selected initiative:

| Input | Requirement |
| --- | --- |
| `policyInitiativeId` | The full resource ID of the policy set definition. |
| `dimension` | The intended compliance dimension, such as `DataResidency` or `BusinessContinuity`. |
| `policyVersion` | An explicit version matching the selected initiative, existing assignments, and deployed service. Replace the version placeholders before use. |
| `policyAssignmentIds` | Full resource IDs of existing assignments corresponding to the initiative and intended scopes. |

Confirm approved Data Residency locations and the desired evaluation mode.
The Business Continuity example uses dummy inputs: replace its initiative ID,
version, and assignment IDs, or remove the block when not selected.

The deployment identity needs Contributor or Owner on the resource group.
Provider registration and access to selected scopes require the permissions
described in the onboarding guide. Granting missing managed-identity roles
separately requires Owner or User Access Administrator on the relevant scopes.
Do not assume resource creation success guarantees the identity has access.

## 1. Download the versioned package

Download all three files from
[`docs/bicep/2026-10-31-preview`](/docs/bicep/2026-10-31-preview)
into one local folder:

```text
2026-10-31-preview\
  main.bicep
  example.bicepparam
  register-scopes.ps1
```

Open PowerShell in that folder:

```powershell
az --version
az bicep version
```

If Bicep is missing, run `az bicep install`. Do not copy role modules from the
legacy package.

## 2. Verify the deployment tenant, subscription, and UK South readiness

Use an existing approved login. These commands do not change the active account
or cloud. This public package uses public ARM, not the private namespace's
Canary endpoint or Canary-resource-group requirement.

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

The supplied example selects `uksouth`. Confirm both UK South and
`2026-10-31-preview` are advertised for the approved subscription. The template
also permits `swedencentral`; use it only after confirming eligibility and
obtaining approval for that region. Public SystemAssigned identity remains
enabled; do not copy the private package's no-MI limitation into this package.
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

## 4. Create the customer parameter file

```powershell
Copy-Item ".\example.bicepparam" ".\production.bicepparam"
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
if (Select-String -Path ".\production.bicepparam" -Pattern '<REQUIRED:') {
  throw "Replace all required placeholders before deployment."
}

az bicep build --file ".\main.bicep" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Bicep compilation failed." }
az bicep build-params --file ".\production.bicepparam" --stdout | Out-Null
if ($LASTEXITCODE -ne 0) { throw "Bicep parameter compilation failed." }
```

Before What-If or creation, run provider validation:

```powershell
az deployment group validate `
  --name "sovereign-view-validation" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam"
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
  --parameters ".\production.bicepparam"
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
  --parameters ".\production.bicepparam" `
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

## Existing assignments and cleanup

The policy assignment IDs in this package are references, not resources managed
by its ARM deployment. Do not remove customer policy assignments as a cleanup
step merely because they were associated with this view. Conversely, do not
assume a view DELETE or failed CREATE leaves them intact. Confirm the service's
applicable lifecycle behavior and follow
[the view deletion guide](/docs/how-to/06-delete-sovereign-view.md).
