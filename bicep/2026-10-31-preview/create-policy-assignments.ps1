#Requires -Version 7.2
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][guid] $ExpectedTenantId,
    [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9._-]{0,62}$')][string] $SovereignViewName,
    [ValidateSet('DataResidency', 'EncryptionAtRest', 'ControlledNetworkExposure', 'BusinessContinuity')]
    [string[]] $Dimensions = @('DataResidency'),
    [string[]] $SubscriptionIds = @(),
    [string[]] $ManagementGroupIds = @(),
    [string[]] $AllowedLocations,
    [ValidateSet('Residency360', 'ResourceOnly')][string] $ResourceEvaluationScope = 'Residency360',
    [ValidateSet('DoNotEnforce', 'Default')][string] $EnforcementMode = 'DoNotEnforce',
    [string] $OverridesPath,
    [Parameter(Mandatory)][string] $OutputDirectory,
    [ValidateSet('swedencentral')][string] $Location = 'swedencentral',
    [bool] $IsWorkload = $true,
    [ValidatePattern('^[a-z][a-z0-9-]{0,7}$')][string] $AssignmentNamePrefix = 'sv'
)

$ErrorActionPreference = 'Stop'
$armEndpoint = 'https://management.azure.com'
$catalog = @(
    @{ dimension = 'DataResidency'; id = 'bebfcba2-e789-4da6-9043-726ef3a00d02' }
    @{ dimension = 'DataResidency'; id = '35877bcb-9bd2-49fc-8a00-4614b3a0e73a' }
    @{ dimension = 'EncryptionAtRest'; id = 'f15f4d95-c59c-4395-9317-be6978d0743f' }
    @{ dimension = 'ControlledNetworkExposure'; id = 'b71f6054-d890-4c78-b809-2ae9dc6a0cfc' }
    @{ dimension = 'ControlledNetworkExposure'; id = 'a3d07baa-2640-4810-9814-c8c4bbfc21a6' }
    @{ dimension = 'BusinessContinuity'; id = '24da7f6e-ca7a-4ede-bef4-25f158872a36' }
)
$selected = @($catalog | Where-Object {
    $_.dimension -in $Dimensions -and
    -not ($_.id -eq '35877bcb-9bd2-49fc-8a00-4614b3a0e73a' -and $ResourceEvaluationScope -eq 'ResourceOnly')
})
if ('DataResidency' -notin $Dimensions) { throw 'Include DataResidency, as in the portal create flow.' }
if (-not $SubscriptionIds.Count -and -not $ManagementGroupIds.Count) { throw 'Select at least one subscription or management group.' }
if ($PSBoundParameters.ContainsKey('AllowedLocations') -and
    (-not $AllowedLocations.Count -or @($AllowedLocations | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count)) {
    throw 'AllowedLocations must contain approved Azure region codes.'
}
$outputPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
if (Test-Path -LiteralPath $outputPath) { throw 'OutputDirectory must be new. Existing files and assignments are never overwritten.' }

$overrides = @{}
if ($OverridesPath) {
    $inputOverrides = @(Get-Content -Raw -LiteralPath $OverridesPath | ConvertFrom-Json -AsHashtable)
    foreach ($item in $inputOverrides) {
        if ($item -isnot [System.Collections.IDictionary]) { throw 'Overrides must be an array of initiative objects.' }
        foreach ($key in $item.Keys) {
            if ($key -notin @('policyInitiativeId', 'policyVersion', 'assignmentParameters')) { throw "Unknown override field: $key" }
        }
        $id = [string]$item.policyInitiativeId
        if ($id -notmatch '^/(?:providers/Microsoft.Management/managementGroups/[^/]+/|subscriptions/[0-9a-f-]+/)?providers/Microsoft.Authorization/policySetDefinitions/([0-9a-f-]{36})$') {
            throw 'Each override requires an approved initiative resource ID.'
        }
        $guid = $Matches[1]
        if ($guid -notin $selected.id -or $overrides.ContainsKey($guid)) { throw "Unknown, unselected, or duplicate initiative override: $id" }
        if ($item.Contains('assignmentParameters') -and $item.assignmentParameters -isnot [System.Collections.IDictionary]) {
            throw "assignmentParameters must be an object: $id"
        }
        if ($item.policyVersion -and $item.policyVersion -notmatch '^\d+\.\d+\.\d+(?:-[a-zA-Z0-9.-]+)?$') {
            throw 'policyVersion must be an explicit version, not a wildcard.'
        }
        $overrides[$guid] = $item
    }
}

$contextJson = az account show --output json --only-show-errors
if ($LASTEXITCODE -ne 0) { throw 'Use an existing approved Azure CLI login.' }
$context = $contextJson -join "`n" | ConvertFrom-Json -AsHashtable
if ($context.tenantId -ne $ExpectedTenantId.ToString() -or $context.environmentName -ne 'AzureCloud') {
    throw 'The active tenant or cloud differs from the approved context. No account switch is performed.'
}
$tokenJson = az account get-access-token --subscription $context.id --resource https://management.azure.com/ --output json --only-show-errors
if ($LASTEXITCODE -ne 0) { throw 'ARM token unavailable.' }
$auth = $tokenJson -join "`n" | ConvertFrom-Json -AsHashtable
$tokenJson = $null
if ($auth.tenant -ne $ExpectedTenantId.ToString()) { throw 'ARM token tenant differs from ExpectedTenantId.' }
$headers = @{ Authorization = "Bearer $($auth.accessToken)" }
$auth.accessToken = $null
function Invoke-PolicyArm([string] $Method, [string] $Path, $Body, [int[]] $Expected = @(200)) {
    $request = @{
        Method = $Method
        Uri = "$ArmEndpoint$Path"
        Headers = $headers
        ContentType = 'application/json'
        SkipHttpErrorCheck = $true
        TimeoutSec = 120
    }
    if ($null -ne $Body) { $request.Body = $Body | ConvertTo-Json -Depth 100 -Compress }
    $response = Invoke-WebRequest @request
    $text = if ($response.Content -is [byte[]]) { [Text.Encoding]::UTF8.GetString($response.Content) } else { [string]$response.Content }
    $payload = if ($text) { $text | ConvertFrom-Json -AsHashtable } else { $null }
    if ([int]$response.StatusCode -notin $Expected) {
        $correlation = $response.Headers['x-ms-correlation-request-id'] -join ','
        throw "ARM $Method $Path returned $($response.StatusCode), code '$($payload.error.code)', correlation '$correlation'."
    }
    return @{ statusCode = [int]$response.StatusCode; body = $payload }
}
function Test-ParameterValue($Value, $Definition, [string] $Name) {
    $valid = switch ($Definition.type) {
        'String' { $Value -is [string] }
        'Boolean' { $Value -is [bool] }
        'Integer' { $Value -is [int] -or $Value -is [long] }
        'Float' { $Value -is [double] -or $Value -is [decimal] -or $Value -is [float] -or $Value -is [int] -or $Value -is [long] }
        'Array' { $Value -is [array] }
        'Object' { $Value -is [System.Collections.IDictionary] }
        default { $false }
    }
    if (-not $valid) { throw "Invalid value type for parameter '$Name' (expected $($Definition.type))." }
    if ($Definition.allowedValues.Count) {
        $values = if ($Definition.type -eq 'Array') { @($Value) } else { ,$Value }
        foreach ($v in $values) {
            $encoded = ConvertTo-Json -InputObject $v -Depth 100 -Compress
            $match = @($Definition.allowedValues | Where-Object {
                (ConvertTo-Json -InputObject $_ -Depth 100 -Compress) -ceq $encoded
            })
            if (-not $match.Count) { throw "Value is outside allowedValues for '$Name'." }
        }
    }
}

$runId = [guid]::NewGuid().ToString('N')
$plan = @{ status = 'Planning'; runId = $runId; tenantId = $ExpectedTenantId.ToString(); armEndpoint = $ArmEndpoint; assignments = @() }
try {
    $scopes = @()
    foreach ($subscriptionId in $SubscriptionIds) {
        $id = [guid]::Parse($subscriptionId).ToString()
        $r = Invoke-PolicyArm GET "/subscriptions/$id`?api-version=2022-12-01"
        if ($r.body.tenantId -ne $ExpectedTenantId.ToString() -or -not $r.body.displayName) { throw "Subscription tenant/name cannot be verified: $id" }
        $scopes += @{ id = "/subscriptions/$id"; viewId = $id; name = $r.body.displayName; kind = 'Subscription' }
    }
    foreach ($managementGroupId in $ManagementGroupIds) {
        $id = $managementGroupId.TrimEnd('/')
        if ($id -match '^/providers/Microsoft.Management/managementGroups/([^/]+)$') { $id = $Matches[1] }
        if ($id -notmatch '^[a-zA-Z0-9_().-]{1,90}$') { throw 'Use a management-group ID or its full resource ID.' }
        $r = Invoke-PolicyArm GET "/providers/Microsoft.Management/managementGroups/$id`?api-version=2020-05-01"
        if ($r.body.properties.tenantId -ne $ExpectedTenantId.ToString() -or -not $r.body.properties.displayName) {
            throw "Management-group tenant/name cannot be verified: $id"
        }
        $scopes += @{ id = "/providers/Microsoft.Management/managementGroups/$id"; viewId = "/providers/Microsoft.Management/managementGroups/$id"; name = $r.body.properties.displayName; kind = 'ManagementGroup' }
    }
    if (@($scopes.id | Sort-Object -Unique).Count -ne $scopes.Count) { throw 'Duplicate scopes are not allowed.' }
    $initiatives = @()
    $residencyLocations = $null
    foreach ($policy in $selected) {
        $override = $overrides[$policy.id]
        $id = "/providers/Microsoft.Authorization/policySetDefinitions/$($policy.id)"
        if ($override) { $id = $override.policyInitiativeId }
        $path = $id
        if ($override.policyVersion) { $path += "/versions/$($override.policyVersion)" }
        $r = Invoke-PolicyArm GET "$path`?api-version=2023-04-01"
        $definition = $r.body.properties
        $version = $definition.version
        if (-not $version) { $version = $definition.metadata.version }
        if ($version -notmatch '^(\d+)\.(\d+)\.(\d+)(-[a-zA-Z0-9.-]+)?$') { throw "Definition has no supported version: $id" }
        $assignmentVersion = "$($Matches[1]).$($Matches[2]).*$($Matches[4])"
        if ($override.policyVersion -and $version -ne $override.policyVersion) { throw "Versioned definition did not match the requested version: $id" }
        $parameters = @{}
        foreach ($p in $definition.parameters.GetEnumerator()) {
            if ($p.Value.Contains('defaultValue') -and $null -ne $p.Value.defaultValue) {
                $parameters[$p.Key] = @{ value = $p.Value.defaultValue }
            }
        }
        if ($PSBoundParameters.ContainsKey('AllowedLocations') -and $definition.parameters.Contains('listOfAllowedLocations')) {
            $parameters.listOfAllowedLocations = @{ value = $AllowedLocations }
        }
        $customParameters = @{}
        if ($override.assignmentParameters) { $customParameters = $override.assignmentParameters }
        foreach ($p in $customParameters.GetEnumerator()) {
            if (-not $definition.parameters.Contains($p.Key)) { throw "Unknown parameter '$($p.Key)' on $id." }
            if ($p.Value -isnot [System.Collections.IDictionary] -or $p.Value.Count -ne 1 -or -not $p.Value.Contains('value')) {
                throw "Use the assignmentParameters format '$($p.Key)': { 'value': ... }."
            }
            if ($p.Key -eq 'listOfAllowedLocations' -and $PSBoundParameters.ContainsKey('AllowedLocations')) {
                throw 'Specify allowed locations once: use AllowedLocations or per-initiative overrides, not both.'
            }
            $parameters[$p.Key] = $p.Value
        }
        foreach ($p in $definition.parameters.GetEnumerator()) {
            if (-not $parameters.Contains($p.Key)) {
                throw "Parameter '$($p.Key)' on $id has no default. Supply AllowedLocations or assignmentParameters before creating any assignments."
            }
            Test-ParameterValue $parameters[$p.Key].value $p.Value $p.Key
            if ($p.Key -match '^effect($|_)' -and $parameters[$p.Key].value -in @('DeployIfNotExists', 'Modify')) {
                throw "Parameter '$($p.Key)' on $id requires an assignment identity. This helper creates no identities; explicitly override the effect to a supported non-remediating value."
            }
        }
        if ($policy.dimension -eq 'DataResidency') {
            $locations = $parameters.listOfAllowedLocations.value
            if (-not $locations.Count -or @($locations | Where-Object { [string]::IsNullOrWhiteSpace($_) }).Count) { throw 'Data Residency requires nonempty approved locations.' }
            if ($null -ne $residencyLocations -and
                (($residencyLocations | Sort-Object -Unique) -join '|') -cne (($locations | Sort-Object -Unique) -join '|')) {
                throw 'DR and R360 must use the same allowed locations.'
            }
            $residencyLocations = $locations
        }
        $ids = @()
        foreach ($scope in $scopes) {
            $name = '{0}-{1}-{2:d3}' -f $AssignmentNamePrefix, $runId.Substring(0,10), ($plan.assignments.Count + 1)
            $assignmentId = "$($scope.id)/providers/Microsoft.Authorization/policyAssignments/$name"
            $displayName = "$SovereignViewName - $($policy.dimension) - $($definition.displayName)"
            $body = @{
                properties = @{
                    policyDefinitionId = $id
                    definitionVersion = $assignmentVersion
                    displayName = $displayName.Substring(0, [Math]::Min(128, $displayName.Length))
                    enforcementMode = $EnforcementMode
                    parameters = $parameters
                    metadata = @{ sovereignViewPolicySetup = $runId }
                }
            }
            $plan.assignments += @{ id = $assignmentId; status = 'Planned'; body = $body }
            $ids += $assignmentId
        }
        $initiatives += @{ policyInitiativeId = $id; policyVersion = $version; dimension = $policy.dimension; policyAssignmentIds = $ids }
    }
    foreach ($a in $plan.assignments) {
        $r = Invoke-PolicyArm GET "$($a.id)?api-version=2024-04-01" $null @(404)
    }
    $properties = @{
        scope = @{
            subscriptions = @($scopes | Where-Object kind -eq 'Subscription' | ForEach-Object { @{ id = $_.viewId; name = $_.name } })
            managementGroups = @($scopes | Where-Object kind -eq 'ManagementGroup' | ForEach-Object { @{ id = $_.viewId; name = $_.name } })
        }
        policyInitiatives = $initiatives
        dimensionSettings = @{ dataResidency = @{ resourceEvaluationScope = $ResourceEvaluationScope; parameters = @{ allowedLocations = $residencyLocations } } }
        isWorkload = $IsWorkload
    }
    $plan.status = 'Preview'
    if (-not $PSCmdlet.ShouldProcess(($scopes.id -join ', '), "Create $($plan.assignments.Count) new $EnforcementMode policy assignments and write $outputPath")) {
        return [pscustomobject]$plan
    }
    [void][IO.Directory]::CreateDirectory($outputPath)
    $manifestPath = Join-Path $outputPath 'manifest.json'
    $plan.status = 'Creating'
    $plan | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $manifestPath -Encoding utf8
    foreach ($a in $plan.assignments) {
        $a.status = 'Creating'
        $plan | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $manifestPath -Encoding utf8
        $r = Invoke-PolicyArm PUT "$($a.id)?api-version=2024-04-01" $a.body @(200,201)
        $verified = Invoke-PolicyArm GET "$($a.id)?api-version=2024-04-01"
        if ($verified.body.properties.metadata.sovereignViewPolicySetup -ne $runId -or
            $verified.body.properties.policyDefinitionId -ine $a.body.properties.policyDefinitionId -or
            $verified.body.properties.enforcementMode -ne $EnforcementMode) { throw "Created assignment verification failed: $($a.id)" }
        $a.status = 'Created'
        $plan | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $manifestPath -Encoding utf8
    }
    $deploymentParameters = @{
        sovereignViewName = @{ value = $SovereignViewName }
        location = @{ value = $Location }
        scopeSubscriptions = @{ value = $properties.scope.subscriptions }
        scopeManagementGroups = @{ value = $properties.scope.managementGroups }
        policyInitiatives = @{ value = $initiatives }
        settings = @{ value = @{ dimensionSettings = $properties.dimensionSettings; isWorkload = $IsWorkload } }
    }
    $properties | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $outputPath 'view-properties.json') -Encoding utf8
    @{
        '$schema' = 'https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#'
        contentVersion = '1.0.0.0'
        parameters = $deploymentParameters
    } | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath (Join-Path $outputPath 'view.parameters.json') -Encoding utf8
    $plan.status = 'Succeeded'
    $plan | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $manifestPath -Encoding utf8
    [pscustomobject]@{ status = 'Succeeded'; outputDirectory = $outputPath; policyInitiatives = $initiatives }
}
catch {
    if ($manifestPath -and (Test-Path -LiteralPath $manifestPath)) {
        $plan.status = 'Failed'
        $plan.error = $_.Exception.Message
        $plan | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath $manifestPath -Encoding utf8
    }
    throw
}
finally {
    $headers.Remove('Authorization')
}
