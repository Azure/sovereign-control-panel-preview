# Deploy a Sovereign View with Bicep

Use this guide to create a Sovereign View with Infrastructure as Code instead
of the Azure portal. The included Bicep package gives you a repeatable,
reviewable deployment that you can use across development, test, and production
environments.

This guide is an alternative to the portal steps in
[Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md).
After the deployment succeeds, continue with the same report and support
modules used by portal deployments.

> [!IMPORTANT]
> Sovereign Control Panel is in an invite-only **Private Preview**. Confirm that
> your tenant and every intended subscription were approved through the
> onboarding process before deploying.

> [!IMPORTANT]
> Private Preview evaluations are read-only and non-enforcing. Keep the policy
> effects supplied in the example parameter file. Do not change them to `Deny`,
> `DeployIfNotExists`, or `Modify`.

## What the package creates

The deployment creates:

- One `Microsoft.Sovereign/sovereignViews` resource with a system-assigned
  managed identity.
- The subscription and management-group scope you select.
- The required Data Residency policy initiative and any optional sovereignty
  dimensions you keep in the parameter file.
- Reader access for the managed identity on every in-scope subscription.
- Optional Resource Policy Contributor access on in-scope subscriptions to
  accelerate the first evaluation.

Management-group role assignments use a separate Bicep deployment because an
Azure resource-group deployment cannot assign roles at management-group scope.

## Before you begin

Complete [Module 1: Prerequisites and roles](/docs/how-to/01-roles%20and%20permissions.md)
and collect the following information:

| Required information | Your value |
| --- | --- |
| Azure tenant ID | |
| Deployment subscription ID | |
| Resource group name and location | |
| Sovereign View name | |
| Sovereign View deployment region | |
| In-scope subscription IDs and display names | |
| In-scope management-group IDs and display names | |
| Data Residency allowed Azure locations | |
| Optional policy dimensions to include | |
| Environment owner and tags | |

The deployment identity needs **Owner** on each in-scope subscription or
management group. If your organization separates duties, use this equivalent
combination:

| Required action | Built-in role |
| --- | --- |
| Register `Microsoft.Sovereign` | Contributor |
| Create policy assignments | Resource Policy Contributor |
| Create role assignments | User Access Administrator |

The identity also needs Contributor or Owner on the resource group where the
Sovereign View will be created.

## Download the Bicep package

Download all files from [`docs/bicep`](/docs/bicep) into one local folder:

```text
bicep/
|- main.bicep
|- example.bicepparam
|- register-scopes.ps1
|- scopeSubscriptionRoleAssignment.bicep
|- scopeManagementGroupRoleAssignment.bicep
```

Open PowerShell in that folder and confirm Azure CLI and Bicep are available:

```powershell
az --version
az bicep version
```

If Bicep is not installed, run:

```powershell
az bicep install
```

## 1. Sign in and select the deployment subscription

Sign in to the approved customer tenant:

```powershell
az login --tenant "<TENANT-ID>"
```

Set and verify the subscription where the Sovereign View resource will be
created:

```powershell
$deploymentSubscriptionId = "<DEPLOYMENT-SUBSCRIPTION-ID>"
az account set --subscription $deploymentSubscriptionId

az account show `
  --query "{Name:name, SubscriptionId:id, TenantId:tenantId}" `
  --output table
```

Confirm the displayed subscription and tenant before continuing.

## 2. Create or confirm the resource group

The resource-group location does not need to match the Sovereign View location.

```powershell
$resourceGroupName = "<RESOURCE-GROUP-NAME>"
$resourceGroupLocation = "<RESOURCE-GROUP-LOCATION>"

az group create `
  --name $resourceGroupName `
  --location $resourceGroupLocation `
  --subscription $deploymentSubscriptionId
```

Continue when `provisioningState` is `Succeeded`.

## 3. Confirm an available deployment region

Query the locations currently exposed by the resource provider in the
deployment subscription:

```powershell
az provider show `
  --namespace Microsoft.Sovereign `
  --subscription $deploymentSubscriptionId `
  --query "resourceTypes[?resourceType=='sovereignViews'].locations[]" `
  --output table
```

The checked-in template allows only `swedencentral`, the supported production
deployment region. Confirm it is returned for the deployment subscription.

The **Sovereign View deployment region** controls where the view resource is
created. The **Data Residency allowed locations** control which Azure locations
the policy evaluates as approved. These are separate choices.

### Add a newly supported deployment region to the template

Use these steps only after the provider-location command returns the new region
for your deployment subscription:

1. Open `main.bicep`.
2. Find the `@allowed` list above `param location`.
3. Add the new Azure region code to the list.
4. Set `param location` in your customer `.bicepparam` file to the same region
   code.
5. Build and run What-If as described in section 6 before deployment.

For example, if the service exposes a new region named `examplelocation`:

```bicep
@allowed([
  'swedencentral'
  'examplelocation'
])
param location string = 'swedencentral'
```

> [!CAUTION]
> Do not add a region only because it is available for other Azure resource
> types. If `Microsoft.Sovereign/sovereignViews` does not return the region for
> your subscription, the deployment will fail with a location availability
> error.

Adding a deployment region does not change the Sovereign View API version. When
Microsoft publishes a new API version, update the literal resource type in
`main.bicep` only after reviewing that version's schema:

```bicep
resource sovereignView 'Microsoft.Sovereign/sovereignViews@<new-api-version>' = {
```

Bicep requires the API version to be a compile-time literal; it cannot be a
parameter.

## 4. Register the resource provider on every scope

Register `Microsoft.Sovereign` on each in-scope subscription and management
group before creating the view. The deployment subscription registers during
deployment, but another in-scope subscription or management group must be
registered separately.

```powershell
.\register-scopes.ps1 `
  -SubscriptionIds '<SUBSCRIPTION-ID-1>','<SUBSCRIPTION-ID-2>' `
  -ManagementGroupIds '<MANAGEMENT-GROUP-ID>'
```

Omit `-ManagementGroupIds` when the view does not include a management group.
Confirm subscription registration:

```powershell
az provider show `
  --namespace Microsoft.Sovereign `
  --subscription "<IN-SCOPE-SUBSCRIPTION-ID>" `
  --query registrationState `
  --output tsv
```

Continue when the result is `Registered`.

## 5. Create the customer parameter file

Keep `example.bicepparam` unchanged as a reference. Create one parameter file
for each customer environment:

```powershell
Copy-Item ".\example.bicepparam" ".\production.bicepparam"
code ".\production.bicepparam"
```

Replace every `<REQUIRED: ...>` placeholder and review every optional value.

### Set the view name, location, and scope

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

For management groups, use the full resource ID:

```bicep
param scopeManagementGroups = [
  {
    id: '/providers/Microsoft.Management/managementGroups/contoso-production'
    name: 'Contoso Production'
  }
]
```

You can use subscriptions, management groups, or both. Individual resource
groups and resources cannot be selected.

### Keep required identity access enabled

```bicep
param assignReaderToScopeSubscription = true
param assignResourcePolicyContributorToScopeSubscription = true
```

Reader is required for report data collection. Resource Policy Contributor is
optional and can accelerate the first evaluation; it does not change the
non-enforcing behavior of the Private Preview report.

### Select Data Residency locations and policy dimensions

Data Residency is required. Replace `listOfAllowedLocations.value` in the Data
Residency policy block with the customer's approved Azure region codes. Keep
only the optional policy blocks the customer approved.

The supplied effects are non-enforcing:

- `Audit` reports a finding.
- `AuditIfNotExists` reports when a related configuration is absent.
- `Disabled` turns off an enforcement-capable behavior.

Do not deploy the example file unchanged.

## 6. Validate and preview

Check that no required placeholders remain:

```powershell
Select-String `
  -Path ".\production.bicepparam" `
  -Pattern '<REQUIRED:'
```

The command should return no matches. Build the template and parameter file:

```powershell
az bicep build --file ".\main.bicep" --stdout | Out-Null
az bicep build-params --file ".\production.bicepparam" --stdout | Out-Null
```

Preview the Azure changes without creating resources:

```powershell
az deployment group what-if `
  --name "sovereign-view-preview" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam"
```

Before approving the preview, confirm:

- The view name and deployment region are correct.
- The scope exactly matches the approved subscriptions and management groups.
- The Data Residency locations and optional dimensions match the customer's
  decisions.
- Policy effects remain non-enforcing.
- No unexpected deletion is proposed.

Role assignments can appear as `Unsupported` in What-If because the new managed
identity does not exist yet. Continue only when the remaining preview is correct
and there are no deployment errors.

## 7. Deploy the Sovereign View

Run the deployment after the customer or deployment approver accepts What-If:

```powershell
az deployment group create `
  --name "sovereign-view-deployment" `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --template-file ".\main.bicep" `
  --parameters ".\production.bicepparam" `
  --output table
```

Continue when the deployment state is `Succeeded`.

## 8. Assign management-group roles

Skip this section when the scope contains subscriptions only. Subscription role
assignments are created by `main.bicep`.

Retrieve the Sovereign View managed identity:

```powershell
$viewName = "<SOVEREIGN-VIEW-NAME>"

$principalId = az resource show `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --resource-type "Microsoft.Sovereign/sovereignViews" `
  --name $viewName `
  --api-version "2026-03-15-preview" `
  --query identity.principalId `
  --output tsv
```

Assign Reader to each in-scope management group:

```powershell
az deployment mg create `
  --management-group-id "<MANAGEMENT-GROUP-ID>" `
  --location "<DEPLOYMENT-LOCATION>" `
  --template-file ".\scopeManagementGroupRoleAssignment.bicep" `
  --parameters principalId=$principalId `
               roleDefinitionIds="['acdd72a7-3385-48ef-bd42-f606fba81ae7']"
```

To include Resource Policy Contributor, pass both role definition IDs:

```powershell
--parameters principalId=$principalId `
             roleDefinitionIds="['acdd72a7-3385-48ef-bd42-f606fba81ae7','36243c78-bf99-498c-9df9-86d9f8d28608']"
```

Repeat the management-group deployment for each selected management group.

## 9. Verify the deployment

Check the view state, scope, and policy dimensions:

```powershell
az resource show `
  --subscription $deploymentSubscriptionId `
  --resource-group $resourceGroupName `
  --resource-type "Microsoft.Sovereign/sovereignViews" `
  --name $viewName `
  --api-version "2026-03-15-preview" `
  --query "{Name:name, Location:location, Status:properties.provisioningState, Scope:properties.scope, Policies:properties.policyInitiatives[].dimension}" `
  --output json
```

Check the managed identity's role assignments on each scope:

```powershell
az role assignment list `
  --assignee $principalId `
  --scope "/subscriptions/<IN-SCOPE-SUBSCRIPTION-ID>" `
  --query "[].roleDefinitionName" `
  --output table
```

Confirm that:

- The status is `Succeeded`.
- The location and scope match the approved configuration.
- The policy dimensions match the customer's choices.
- Reader appears on every scope.
- Resource Policy Contributor appears when selected.

Allow up to 24 hours for the first report. Resource Policy Contributor can
reduce the first evaluation time, but timing varies by scope and service load.

## 10. Open the sovereignty control report

Continue with
[Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md).
You do not need to redeploy Bicep to refresh the report.

## Troubleshooting

| Problem | What to do |
| --- | --- |
| The selected location is unavailable | Rerun the provider-location query. Use only a returned location and update both the `@allowed` list and customer parameter when adding a newly supported region. |
| `Microsoft.Sovereign` registration fails | Confirm Contributor or Owner on the scope and register every in-scope subscription and management group. |
| The Bicep build reports a placeholder or type error | Replace all required placeholders and restore the structure from `example.bicepparam`. |
| What-If shows role assignments as `Unsupported` | The managed identity is created during deployment. Continue only when the rest of What-If is correct. |
| A policy parameter is rejected | Restore the non-enforcing values from `example.bicepparam`; allowed values differ by initiative. |
| The report is empty | Verify Reader on every scope and allow time for the first evaluation. |
| A failed resource conflicts during retry | Inspect and remove the failed view, then retry with a new view name. |
| Scope or settings must change | Private Preview does not support editing an existing view. Delete it, update the parameter file, and create a new view. |

For additional issues, see
[Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md)
or email **Azscp@microsoft.com**.

## Delete the deployment

Before deleting the view, record its managed identity ID so you can remove any
dedicated role assignments. Then follow
[Module 6: Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md).

Deleting the Sovereign View removes the policy assignments it created. Verify
that the view and its dedicated role assignments are removed before considering
cleanup complete.