#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Assigns Reader and Resource Policy Contributor roles to a Sovereign View's
    managed identity across all subscriptions and management groups in its scope.

.DESCRIPTION
    Interactive workflow:
      1. Lists all Sovereign Views accessible to the logged-in user (via Resource Graph)
      2. User selects a view from the numbered list
      3. Fetches the view's managed identity principal ID and scope
      4. Pre-checks which role assignments already exist on each scope item
      5. Displays a status table (existing vs missing)
      6. On user confirmation, creates only the missing assignments

.PARAMETER DryRun
    Print what would be assigned without making any changes.

.PARAMETER ApiVersion
    ARM API version for microsoft.sovereign/sovereignViews.
    Defaults to 2025-02-27-preview.

.EXAMPLE
    .\assign-roles.ps1
    .\assign-roles.ps1 -DryRun
    .\assign-roles.ps1 -ApiVersion "2025-02-27-preview"
#>

param(
    [switch]$DryRun,
    [string]$ApiVersion = "2025-02-27-preview"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ─── Constants ────────────────────────────────────────────────────────────────

$ResourceType = "microsoft.sovereign/sovereignViews"
$Roles        = @("Reader", "Resource Policy Contributor")

# ─── Helpers ──────────────────────────────────────────────────────────────────

function Write-Banner {
    param([string]$Title)
    $line = "═" * 65
    Write-Host ""
    Write-Host "  $line" -ForegroundColor Cyan
    Write-Host "  $Title" -ForegroundColor Cyan
    Write-Host "  $line" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step   { param([string]$Msg) Write-Host "  ▶ $Msg" -ForegroundColor Yellow }
function Write-Ok     { param([string]$Msg) Write-Host "  ✅ $Msg" -ForegroundColor Green }
function Write-Warn   { param([string]$Msg) Write-Host "  ⚠  $Msg" -ForegroundColor Yellow }
function Write-Err    { param([string]$Msg) Write-Host "  ✖  $Msg" -ForegroundColor Red }
function Write-Info   { param([string]$Msg) Write-Host "     $Msg" -ForegroundColor Gray }

# ─── Step 1 · Verify az CLI login ─────────────────────────────────────────────

Write-Banner "Sovereign View — Role Assignment"

if ($DryRun) {
    Write-Warn "DRY RUN mode is ON — no role assignments will be created."
    Write-Host ""
}

Write-Step "Verifying Azure CLI login..."
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Err "Not logged in. Run 'az login' and try again."
    exit 1
}
Write-Ok "Signed in as : $($account.user.name)"
Write-Info "Tenant       : $($account.tenantId)"
Write-Info "Subscription : $($account.name) ($($account.id))"

# ─── Step 2 · Ensure resource-graph extension ────────────────────────────────

Write-Step "Checking resource-graph extension..."
$rgExt = az extension show --name resource-graph 2>$null
if (-not $rgExt) {
    Write-Step "Installing resource-graph extension (one-time)..."
    az extension add --name resource-graph --only-show-errors
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to install resource-graph extension. Install manually: az extension add --name resource-graph"
        exit 1
    }
}
Write-Ok "resource-graph extension ready."

# ─── Step 3 · Discover Sovereign Views ───────────────────────────────────────

Write-Step "Searching for Sovereign Views across all accessible subscriptions..."
$kqlQuery = "Resources | where type =~ '$ResourceType' | project id, name, resourceGroup, subscriptionId | order by name asc"

$graphRaw = az graph query -q $kqlQuery --first 1000 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Err "Resource Graph query failed: $graphRaw"
    exit 1
}

$graphResult = $graphRaw | ConvertFrom-Json
$views = $graphResult.data

if (-not $views -or @($views).Count -eq 0) {
    Write-Err "No Sovereign Views found in any accessible subscription."
    Write-Info "Make sure the microsoft.sovereign resource provider is registered and you have Reader access."
    exit 1
}

$views = @($views)
Write-Ok "Found $($views.Count) Sovereign View(s)."

# ─── Step 4 · Interactive view selection ─────────────────────────────────────

Write-Banner "Available Sovereign Views"

for ($i = 0; $i -lt $views.Count; $i++) {
    $v = $views[$i]
    $label = "[{0}]" -f ($i + 1)
    Write-Host ("  {0,-5} {1}" -f $label, $v.name) -ForegroundColor Cyan
    Write-Info "       Resource Group : $($v.resourceGroup)"
    Write-Info "       Subscription   : $($v.subscriptionId)"
    Write-Host ""
}

$selectedView = $null
$displayList  = $views

while (-not $selectedView) {
    $prompt  = "  Select a view by number (1 – $($displayList.Count)) or type to search by name"
    $rawInput = (Read-Host $prompt).Trim()

    if ([string]::IsNullOrWhiteSpace($rawInput)) { continue }

    $selIdx = 0
    if ([int]::TryParse($rawInput, [ref]$selIdx)) {
        if ($selIdx -ge 1 -and $selIdx -le $displayList.Count) {
            $selectedView = $displayList[$selIdx - 1]
        } else {
            Write-Warn "Invalid number. Please enter a number between 1 and $($displayList.Count)."
        }
    } else {
        $matches = @($views | Where-Object { $_.name -like "*$rawInput*" })

        if ($matches.Count -eq 0) {
            Write-Warn "No views matching '$rawInput'. Showing full list."
            Write-Host ""
            $displayList = $views
            for ($i = 0; $i -lt $displayList.Count; $i++) {
                $v = $displayList[$i]
                $label = "[{0}]" -f ($i + 1)
                Write-Host ("  {0,-5} {1}" -f $label, $v.name) -ForegroundColor Cyan
                Write-Info "       Resource Group : $($v.resourceGroup)"
                Write-Info "       Subscription   : $($v.subscriptionId)"
                Write-Host ""
            }
        } elseif ($matches.Count -eq 1) {
            $selectedView = $matches[0]
        } else {
            Write-Host ""
            Write-Host "  $($matches.Count) views matching '$rawInput':" -ForegroundColor Cyan
            Write-Host ""
            $displayList = $matches
            for ($i = 0; $i -lt $displayList.Count; $i++) {
                $v = $displayList[$i]
                $label = "[{0}]" -f ($i + 1)
                Write-Host ("  {0,-5} {1}" -f $label, $v.name) -ForegroundColor Cyan
                Write-Info "       Resource Group : $($v.resourceGroup)"
                Write-Info "       Subscription   : $($v.subscriptionId)"
                Write-Host ""
            }
        }
    }
}

Write-Host ""
Write-Ok "Selected → $($selectedView.name)  (Resource Group: $($selectedView.resourceGroup))"

# ─── Step 5 · Fetch resource details ─────────────────────────────────────────

Write-Step "Setting active subscription to $($selectedView.subscriptionId)..."
az account set --subscription $selectedView.subscriptionId 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Err "Failed to set subscription context to $($selectedView.subscriptionId)."
    exit 1
}

Write-Step "Fetching Sovereign View resource details (api-version: $ApiVersion)..."
$resourceRaw = az resource show --ids $selectedView.id --api-version $ApiVersion 2>&1
if ($LASTEXITCODE -ne 0) {
    # Fallback: try without explicit api-version (az CLI picks latest preview)
    Write-Warn "API version $ApiVersion failed, retrying without explicit version..."
    $resourceRaw = az resource show --ids $selectedView.id 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Err "Failed to retrieve Sovereign View details."
        Write-Info $resourceRaw
        exit 1
    }
}
$resource = $resourceRaw | ConvertFrom-Json

# ─── Step 6 · Extract managed identity ───────────────────────────────────────

$principalId = $null
if ($resource.PSObject.Properties["identity"] -and $resource.identity) {
    $principalId = $resource.identity.principalId
}

if ([string]::IsNullOrWhiteSpace($principalId)) {
    Write-Err "Sovereign View '$($selectedView.name)' does not have a managed identity."
    Write-Info "Enable the system-assigned managed identity on the resource and try again."
    Write-Info "Identity property found: $($resource.identity | ConvertTo-Json -Depth 3)"
    exit 1
}
Write-Ok "Managed Identity Principal ID: $principalId"

# ─── Step 7 · Parse scope ────────────────────────────────────────────────────

$scopeProps = $resource.properties.scope
if (-not $scopeProps) {
    Write-Err "Could not find 'properties.scope' on the Sovereign View resource."
    Write-Info "Raw properties: $($resource.properties | ConvertTo-Json -Depth 5)"
    exit 1
}

# Build a unified list of scope items
# Each item: { DisplayName, ArmScope }
$scopeItems = [System.Collections.Generic.List[hashtable]]::new()

if ($scopeProps.PSObject.Properties["subscriptions"] -and $scopeProps.subscriptions) {
    foreach ($sub in $scopeProps.subscriptions) {
        $scopeItems.Add(@{
            DisplayName = "$($sub.name) ($($sub.id))"
            ArmScope    = "/subscriptions/$($sub.id)"
            Kind        = "Subscription"
        })
    }
}

if ($scopeProps.PSObject.Properties["managementGroups"] -and $scopeProps.managementGroups) {
    foreach ($mg in $scopeProps.managementGroups) {
        $mgDisplayName = if ($mg.PSObject.Properties["name"] -and $mg.name) { $mg.name } else { $mg.id.Split("/")[-1] }
        $scopeItems.Add(@{
            DisplayName = "$mgDisplayName ($($mg.id.Split('/')[-1]))"
            ArmScope    = $mg.id   # Already a full ARM path
            Kind        = "ManagementGroup"
        })
    }
}

if ($scopeItems.Count -eq 0) {
    Write-Warn "No subscriptions or management groups found in the Sovereign View scope. Nothing to assign."
    exit 0
}

# ─── Step 8 · Display scope ───────────────────────────────────────────────────

Write-Banner "Sovereign View Scope"
Write-Host "  Name             : $($selectedView.name)" -ForegroundColor White
Write-Host "  Resource Group   : $($selectedView.resourceGroup)" -ForegroundColor White
Write-Host "  Principal ID     : $principalId" -ForegroundColor White
Write-Host ""

$subs = $scopeItems | Where-Object { $_.Kind -eq "Subscription" }
$mgs  = $scopeItems | Where-Object { $_.Kind -eq "ManagementGroup" }

Write-Host "  Subscriptions ($(@($subs).Count)):" -ForegroundColor White
foreach ($s in $subs) { Write-Info "    • $($s.DisplayName)" }
Write-Host ""
Write-Host "  Management Groups ($(@($mgs).Count)):" -ForegroundColor White
foreach ($mg in $mgs) { Write-Info "    • $($mg.DisplayName)" }
Write-Host ""

# ─── Step 9 · Pre-check existing assignments ─────────────────────────────────

Write-Banner "Checking Existing Role Assignments"
Write-Info "Querying assignments for $($scopeItems.Count) scope item(s) × $($Roles.Count) role(s)..."
Write-Info "This may take a few seconds..."
Write-Host ""

# assignmentMatrix[$armScope][$role] = $true | $false
$assignmentMatrix = @{}

foreach ($item in $scopeItems) {
    $armScope = $item.ArmScope
    $assignmentMatrix[$armScope] = @{}

    foreach ($role in $Roles) {
        try {
            $existing = az role assignment list `
                --scope $armScope `
                --assignee $principalId `
                --role $role `
                --query "[0].id" `
                --output tsv 2>$null
            $assignmentMatrix[$armScope][$role] = (-not [string]::IsNullOrWhiteSpace($existing))
        }
        catch {
            # Permission to list may be missing — treat as unknown/missing
            Write-Warn "Could not query role assignments on $armScope — will attempt assignment."
            $assignmentMatrix[$armScope][$role] = $false
        }
    }
}

# ─── Step 10 · Print status table ─────────────────────────────────────────────

$scopeColW = 55
$roleColW  = 22

$header = "  {0,-$scopeColW}  {1,-$roleColW}  {2}" -f "Scope", "Reader", "Resource Policy Contributor"
$divider = "  {0}  {1}  {2}" -f ("-" * $scopeColW), ("-" * $roleColW), ("-" * 30)

Write-Host $header -ForegroundColor White
Write-Host $divider -ForegroundColor DarkGray

foreach ($item in $scopeItems) {
    $armScope   = $item.ArmScope
    $shortScope = if ($armScope.Length -gt $scopeColW) {
        "…" + $armScope.Substring($armScope.Length - ($scopeColW - 1))
    } else { $armScope }

    $readerTxt = if ($assignmentMatrix[$armScope]["Reader"]) {
        "✅ Assigned   "
    } else { "❌ Missing    " }

    $rpcTxt = if ($assignmentMatrix[$armScope]["Resource Policy Contributor"]) {
        "✅ Assigned"
    } else { "❌ Missing " }

    $rowColor = if ((-not $assignmentMatrix[$armScope]["Reader"]) -or
                    (-not $assignmentMatrix[$armScope]["Resource Policy Contributor"])) {
        "Gray"
    } else { "DarkGray" }

    Write-Host ("  {0,-$scopeColW}  {1,-$roleColW}  {2}" -f $shortScope, $readerTxt, $rpcTxt) -ForegroundColor $rowColor
}

Write-Host ""

# Build list of missing assignments
$toAssign = [System.Collections.Generic.List[hashtable]]::new()
foreach ($item in $scopeItems) {
    foreach ($role in $Roles) {
        if (-not $assignmentMatrix[$item.ArmScope][$role]) {
            $toAssign.Add(@{
                DisplayName = $item.DisplayName
                ArmScope    = $item.ArmScope
                Role        = $role
            })
        }
    }
}

$alreadyCount = ($scopeItems.Count * $Roles.Count) - $toAssign.Count

if ($toAssign.Count -eq 0) {
    Write-Ok "All $($scopeItems.Count * $Roles.Count) role assignments already exist. Nothing to do."
    exit 0
}

Write-Host ("  → {0} assignment(s) will be created.  {1} already exist (skipped)." -f $toAssign.Count, $alreadyCount) -ForegroundColor Yellow
Write-Host ""

# ─── Step 11 · Dry run output ────────────────────────────────────────────────

if ($DryRun) {
    Write-Banner "Dry Run — Commands That Would Execute"
    foreach ($a in $toAssign) {
        Write-Host ("  az role assignment create ``") -ForegroundColor DarkGray
        Write-Host ("    --role '$($a.Role)' ``") -ForegroundColor DarkGray
        Write-Host ("    --assignee-object-id $principalId ``") -ForegroundColor DarkGray
        Write-Host ("    --assignee-principal-type ServicePrincipal ``") -ForegroundColor DarkGray
        Write-Host ("    --scope '$($a.ArmScope)'") -ForegroundColor DarkGray
        Write-Host ""
    }
    Write-Warn "Dry run complete. Re-run without -DryRun to apply changes."
    exit 0
}

# ─── Step 12 · Confirm ───────────────────────────────────────────────────────

$confirm = Read-Host "  Proceed with $($toAssign.Count) assignment(s)? [Y/N]"
if ($confirm -notmatch "^[Yy]$") {
    Write-Host ""
    Write-Warn "Operation cancelled by user. No changes were made."
    exit 0
}

# ─── Step 13 · Assign roles ───────────────────────────────────────────────────

Write-Banner "Assigning Roles"

$created = 0
$failed  = 0
$failDetails = [System.Collections.Generic.List[string]]::new()

foreach ($a in $toAssign) {
    Write-Step "[$($created + $failed + 1)/$($toAssign.Count)]  '$($a.Role)'  on  $($a.DisplayName)"

    $output = az role assignment create `
        --role          $a.Role `
        --assignee-object-id $principalId `
        --assignee-principal-type ServicePrincipal `
        --scope         $a.ArmScope `
        --output none 2>&1

    if ($LASTEXITCODE -eq 0) {
        Write-Ok "  Assigned."
        $created++
    } else {
        $errMsg = ($output -join " ").Trim()
        # Role assignment already exists is not a real failure
        if ($errMsg -match "already exists|RoleAssignmentExists") {
            Write-Warn "  Already exists (race condition — skipped)."
            $created++
        } else {
            Write-Err "  FAILED: $errMsg"
            $failed++
            $failDetails.Add("$($a.Role) on $($a.ArmScope) → $errMsg")
        }
    }
}

# ─── Step 14 · Final summary ─────────────────────────────────────────────────

Write-Banner "Summary"
Write-Host "  Sovereign View   : $($selectedView.name)" -ForegroundColor White
Write-Host "  Principal ID     : $principalId" -ForegroundColor White
Write-Host ""
Write-Host ("  ✅ Created        : {0}" -f $created) -ForegroundColor Green
Write-Host ("  ⚠  Pre-existing   : {0}" -f $alreadyCount) -ForegroundColor Yellow
if ($failed -gt 0) {
    Write-Host ("  ✖  Failed         : {0}" -f $failed) -ForegroundColor Red
    Write-Host ""
    Write-Host "  Failed details:" -ForegroundColor Red
    foreach ($d in $failDetails) { Write-Err "    $d" }
}
Write-Host ""

if ($failed -gt 0) {
    exit 1
} else {
    Write-Ok "Done. Role assignment complete."
    exit 0
}