# Private.RegEnvDev2608: Denmark East test package

This package creates a Sovereign View using
`Private.RegEnvDev2608/sovereignViews@2026-10-31-preview` in Denmark East
(`denmarkeast`). It is a separate private test package; the
`Microsoft.Sovereign` packages remain unchanged.

The request shape matches the [2026-10-31-preview package](/docs/bicep/2026-10-31-preview):
existing policy-assignment references, optional Business Continuity examples,
and typed `settings` for dimension evaluation, workload status, and regulatory
document selection. No role or policy assignment resources are deployed.
Policy definition and assignment IDs still use `Microsoft.Authorization`.

Managed identity is intentionally omitted: this private registration does not
support `SystemAssigned`. The template exports only `sovereignViewId`, not
`principalId`. This does not change the public Microsoft.Sovereign templates.

> [!IMPORTANT]
> Confirm the private service deployment supports the published
> `2026-10-31-preview` creation contract, including existing
> `policyAssignmentIds`. A private namespace or an advertised API version does
> not by itself establish request compatibility. This package does not deploy
> service updates.

> [!CAUTION]
> Use **dedicated, disposable policy assignments**, never shared assignments,
> with this private test package. The private service deletes referenced
> assignments when deleting a view, and failed-create rollback can delete them
> too. An assignment being supplied as an existing reference does not protect
> it from cleanup. Do not use shared assignments until the service's ownership
> handling is corrected.

## Prepare the private test deployment

Download all four files in this directory together into a working folder.
Use PowerShell 7, Azure CLI, and an existing approved login. Do not change tenant
or cloud configuration as an incidental part of testing.

**Use an existing Canary-region resource group** (`eastus2euap` or
`centraluseuap`) for ARM template deployment. The Sovereign View itself remains
in `denmarkeast`. A production-region resource group can validate successfully
but fail during deployment with `InvalidResourceNamespace`, even when submitted
to a Canary endpoint. Do not create a new group or register features without
the environment owner's approval.

Set and verify the test context without changing the active account:

```powershell
$expectedTenantId = "<APPROVED-TEST-TENANT-ID>"
$subscriptionId = "<TEST-SUBSCRIPTION-ID>"
$resourceGroupName = "<EXISTING-CANARY-RESOURCE-GROUP>"
$armEndpoint = "https://eastus2euap.management.azure.com"
$namespace = "Private.RegEnvDev2608"
$apiVersion = "2026-10-31-preview"
$deploymentApiVersion = "2025-04-01"

$tenantId = az account show --subscription $subscriptionId --query tenantId --output tsv
if ($LASTEXITCODE -ne 0 -or $tenantId -ne $expectedTenantId) {
  throw "Use the approved tenant context before continuing."
}

$groupLocation = az rest --method get `
  --url "$armEndpoint/subscriptions/$subscriptionId/resourceGroups/${resourceGroupName}?api-version=2021-04-01" `
  --resource https://management.azure.com/ `
  --subscription $subscriptionId --query location --output tsv
if ($LASTEXITCODE -ne 0 -or $groupLocation -notin @("eastus2euap", "centraluseuap")) {
  throw "Select an existing approved Canary-region resource group."
}

az rest --method get `
  --url "$armEndpoint/subscriptions/$subscriptionId/providers/${namespace}?api-version=2021-04-01" `
  --resource https://management.azure.com/ `
  --subscription $subscriptionId `
  --query "resourceTypes[?resourceType=='sovereignViews'].{Locations:locations, ApiVersions:apiVersions}" `
  --output json
```

Confirm that the provider exposes Denmark East and the intended API version
for this subscription. The template permits only `denmarkeast` and defaults to
that region.

If provider registration is required and authorized, the helper from **this**
package uses explicit Canary REST URLs without changing the configured cloud:

```powershell
.\register-scopes.ps1 `
  -SubscriptionIds '<TEST-SUBSCRIPTION-ID>' `
  -ManagementGroupIds '<TEST-MANAGEMENT-GROUP-ID>'
```

Omit a scope argument when no items of that kind are selected. Management-group
registration does not register subscriptions within that group; register
selected subscriptions individually.

## Set parameters and compile

```powershell
Copy-Item ".\example.bicepparam" ".\denmark.bicepparam"
```

Replace every required placeholder with approved test values. Every selected
initiative must reference existing policy assignments corresponding to the
initiative and selected scopes. Replace the Business Continuity dummy values,
or remove that optional block.

Supply subscription and management-group display names. Although the published
schema and Bicep input type allow omitted labels, the current private service
rejects them.

Use versions verified against the dedicated assignments and private service.
The private allowed-location resolver currently reads the latest ARM initiative
definition and can reject a valid older minor-pinned assignment. Do not alter
shared assignments to bypass this limitation. Azure Policy's assignment
`definitionVersion` wildcard and the view's `policyVersion` are separate fields.

For Residency360, the example includes both DR and R360 associations. Supply
the correct existing definition, version, and assignment IDs for R360 as well
as DR. Delete the R360 block when selecting ResourceOnly instead.

The view's deployment region and Data Residency allowed locations are separate
settings. This variant changes the deployment region, not the default
evaluation settings. Supply approved locations in
`settings.dimensionSettings.dataResidency.parameters.allowedLocations`; do not
assume they must equal `denmarkeast`. Keep or override the other `settings`
fields as described in the
[parameter guide](/docs/how-to/03c-deploy-sovereign-view-with-bicep-2026-10-31-preview.md#evaluation-settings-and-defaults).
Use the private commands in this README rather than the public guide's
provider or read-back commands.

```powershell
if (Select-String -Path ".\denmark.bicepparam" -Pattern '<REQUIRED:') {
  throw "Replace all required placeholders before deployment."
}

az bicep build --file ".\main.bicep" --outfile ".\main.json"
if ($LASTEXITCODE -ne 0) { throw "Bicep compilation failed." }
az bicep build-params --file ".\denmark.bicepparam" --outfile ".\denmark.parameters.json"
if ($LASTEXITCODE -ne 0) { throw "Bicep parameter compilation failed." }
```

## Validate and deploy through ARM Canary

Do not use the default `az deployment group create` endpoint for this private
namespace. Submit the compiled Bicep template as a real ARM deployment through
Canary. Keep generated JSON and customer parameter files in the working folder.

```powershell
$deploymentName = "private-sv-dk-$(Get-Date -Format yyyyMMddHHmmss)"
$deploymentId = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Resources/deployments/$deploymentName"
$deploymentUri = "${armEndpoint}${deploymentId}?api-version=$deploymentApiVersion"
$parameters = Get-Content -Raw ".\denmark.parameters.json" | ConvertFrom-Json
@{
  properties = @{
    mode = "Incremental"
    template = Get-Content -Raw ".\main.json" | ConvertFrom-Json
    parameters = $parameters.parameters
  }
} | ConvertTo-Json -Depth 100 | Set-Content ".\deployment-request.json" -Encoding utf8

az rest --method post `
  --url "${armEndpoint}${deploymentId}/validate?api-version=$deploymentApiVersion" `
  --resource https://management.azure.com/ --subscription $subscriptionId `
  --body '@deployment-request.json'
if ($LASTEXITCODE -ne 0) { throw "ARM validation failed." }
```

Review the one private resource, Denmark East location, scope, existing
assignment associations, and settings. Only after approving resource creation:

```powershell
az rest --method put --url $deploymentUri `
  --resource https://management.azure.com/ --subscription $subscriptionId `
  --body '@deployment-request.json' --output none
if ($LASTEXITCODE -ne 0) { throw "ARM deployment submission failed." }

$deadline = [DateTimeOffset]::UtcNow.AddMinutes(10)
do {
  $deployment = az rest --method get --url $deploymentUri `
    --resource https://management.azure.com/ --subscription $subscriptionId `
    --output json | ConvertFrom-Json
  if ($LASTEXITCODE -ne 0) { throw "Deployment status could not be read." }
  $state = $deployment.properties.provisioningState
  if ($state -in @("Succeeded", "Failed", "Canceled")) { break }
  Start-Sleep -Seconds 10
} while ([DateTimeOffset]::UtcNow -lt $deadline)
if ($state -ne "Succeeded") { throw "Deployment did not succeed: $state" }

$viewId = $deployment.properties.outputs.sovereignViewId.value
az rest --method get `
  --url "${armEndpoint}${viewId}?api-version=$apiVersion" `
  --resource https://management.azure.com/ --subscription $subscriptionId `
  --query "{Id:id, Location:location, Status:properties.provisioningState, Properties:properties}" `
  --output json
```

Confirm that the returned resource ID contains
`/providers/Private.RegEnvDev2608/sovereignViews/`, the location is
`denmarkeast`, and the properties match the test configuration. Verify
operational status separately. With MI omitted, `MIMissing` is an expected
limitation; a fresh summary can remain `Generating` until its first evaluation.
Template deployment success is not a claim that the report is fully populated.

Delete test views only when all referenced assignments are disposable fixtures
owned by that test. Verify that the view and fixture assignments are gone after
the asynchronous DELETE completes. Do not delete earlier views that reference
shared assignments merely to clean up deployment history.
