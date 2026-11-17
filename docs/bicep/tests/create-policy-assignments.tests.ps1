#Requires -Version 7.2
$ErrorActionPreference = 'Stop'
$packageRoot = Split-Path $PSScriptRoot
$tenant = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
$subscription = '11111111-1111-1111-1111-111111111111'
$dr = 'bebfcba2-e789-4da6-9043-726ef3a00d02'
$r360 = '35877bcb-9bd2-49fc-8a00-4614b3a0e73a'
$ear = 'f15f4d95-c59c-4395-9317-be6978d0743f'
$temp = Join-Path ([IO.Path]::GetTempPath()) "sv-policy-tests-$([guid]::NewGuid().ToString('N'))"
[void][IO.Directory]::CreateDirectory($temp)
$script:checks = 0
function Assert($Condition, [string] $Message) {
    if (-not $Condition) { throw $Message }
    $script:checks++
}
function Reset-Mock {
    $script:mock = @{ calls = [Collections.Generic.List[object]]::new(); assignments = @{}; putCount = 0; failPut = 0; collision = $false; wrongTenant = $false; badVerification = $false; remediationDefault = $false }
}
function az {
    $global:LASTEXITCODE = 0
    if ($args[0] -eq 'account' -and $args[1] -eq 'show') {
        @{ tenantId = $tenant; environmentName = 'AzureCloud'; id = $subscription } | ConvertTo-Json -Compress
    } elseif ($args[1] -eq 'get-access-token') {
        @{ tenant = $tenant; accessToken = 'offline-token' } | ConvertTo-Json -Compress
    } else { throw 'Unexpected CLI call.' }
}
function Invoke-WebRequest {
    param($Method, $Uri, $Headers, $ContentType, $SkipHttpErrorCheck, $TimeoutSec, $Body)
    $mock.calls.Add(@{ method = $Method; uri = $Uri; body = $Body })
    $path = ([uri]$Uri).AbsolutePath
    $status = 200
    $payload = $null
    if ($path -match '/policyAssignments/') {
        if ($Method -eq 'PUT') {
            $mock.putCount++
            if ($mock.putCount -eq $mock.failPut) {
                $status = 403
                $payload = @{ error = @{ code = 'AuthorizationFailed' } }
            } else {
                $payload = $Body | ConvertFrom-Json -AsHashtable
                $payload.id = $path
                $mock.assignments[$path] = $payload
            }
        } elseif ($mock.assignments.ContainsKey($path)) {
            $payload = $mock.assignments[$path] | ConvertTo-Json -Depth 100 | ConvertFrom-Json -AsHashtable
            if ($mock.badVerification) { $payload.properties.metadata.sovereignViewPolicySetup = 'different-owner' }
        } elseif ($mock.collision) {
            $payload = @{ id = $path }
        } else {
            $status = 404
            $payload = @{ error = @{ code = 'PolicyAssignmentNotFound' } }
        }
    } elseif ($path -match '/policySetDefinitions/([0-9a-f-]+)(/versions/([^/]+))?$') {
        $id = $Matches[1]
        $version = if ($Matches[3]) { $Matches[3] } else { '1.2.3-preview' }
        $parameters = @{ effect = @{ type = 'String'; defaultValue = 'Deny'; allowedValues = @('Audit', 'Deny', 'Disabled') } }
        if ($mock.remediationDefault) {
            $parameters.effect = @{ type = 'String'; defaultValue = 'DeployIfNotExists'; allowedValues = @('DeployIfNotExists', 'Disabled') }
        }
        if ($id -in @($dr, $r360)) {
            $parameters.listOfAllowedLocations = @{ type = 'Array' }
        } else {
            $parameters.enabled = @{ type = 'Boolean'; defaultValue = $false; allowedValues = @($true, $false) }
            $parameters.skus = @{ type = 'Array'; defaultValue = @('one', 'two'); allowedValues = @('one', 'two') }
        }
        $payload = @{ id = ($path -replace '/versions/[^/]+$', ''); properties = @{ version = $version; displayName = 'Definition'; parameters = $parameters } }
    } elseif ($path -eq "/subscriptions/$subscription") {
        $payload = @{ tenantId = if ($mock.wrongTenant) { 'other' } else { $tenant }; displayName = 'Evaluation subscription' }
    } elseif ($path -match '^/providers/Microsoft.Management/managementGroups/[^/]+$') {
        $payload = @{ properties = @{ tenantId = $tenant; displayName = 'Evaluation MG' } }
    } else { throw "Unexpected request: $Method $Uri" }
    [pscustomobject]@{
        StatusCode = $status
        Content = ($payload | ConvertTo-Json -Depth 100 -Compress)
        Headers = @{ 'x-ms-correlation-request-id' = 'offline-correlation' }
    }
}
function Reject([string] $Script, [hashtable] $Arguments, [string] $Pattern) {
    $caught = $false
    try { $null = & $Script @Arguments -Confirm:$false } catch { $caught = $_.Exception.Message -match $Pattern }
    Assert $caught "Expected rejection: $Pattern"
}
try {
    foreach ($variant in @(
        @{ directory = '2026-10-31-preview'; endpoint = 'https://management.azure.com'; location = 'swedencentral' }
    )) {
        $script = Join-Path $packageRoot "$($variant.directory)\create-policy-assignments.ps1"
        $prefix = 'public'
        Reset-Mock
        $out = Join-Path $temp "$prefix-success"
        $overrides = Join-Path $temp "$prefix-overrides.json"
        @(@{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$ear"; policyVersion = '1.1.0-preview'; assignmentParameters = @{ effect = @{ value = 'Audit' }; enabled = @{ value = $true } } }) |
            ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $overrides
        $arguments = @{
            ExpectedTenantId = $tenant; SovereignViewName = 'example-view'; SubscriptionIds = @($subscription)
            ManagementGroupIds = @('/providers/Microsoft.Management/managementGroups/example-mg')
            AllowedLocations = @('swedencentral'); OutputDirectory = $out
            Dimensions = @('DataResidency', 'EncryptionAtRest', 'ControlledNetworkExposure', 'BusinessContinuity')
            OverridesPath = $overrides
        }
        $result = & $script @arguments -Confirm:$false
        Assert ($result.status -eq 'Succeeded' -and $result.policyInitiatives.Count -eq 6) 'All dimension expansion failed.'
        Assert ($mock.putCount -eq 12) 'Expected one PA per initiative per scope.'
        Assert (@($mock.calls | Where-Object { -not $_.uri.StartsWith($variant.endpoint) }).Count -eq 0) 'Wrong default endpoint.'
        $manifest = Get-Content -Raw (Join-Path $out 'manifest.json') | ConvertFrom-Json -AsHashtable
        $params = Get-Content -Raw (Join-Path $out 'view.parameters.json') | ConvertFrom-Json -AsHashtable
        $properties = Get-Content -Raw (Join-Path $out 'view-properties.json') | ConvertFrom-Json -AsHashtable
        Assert ($manifest.status -eq 'Succeeded' -and @($manifest.assignments | Where-Object status -ne 'Created').Count -eq 0) 'Manifest not complete.'
        Assert ($params.parameters.location.value -eq $variant.location) 'Wrong default view location.'
        Assert ($params.parameters.scopeSubscriptions.value[0].name -eq 'Evaluation subscription' -and $params.parameters.scopeManagementGroups.value[0].name -eq 'Evaluation MG') 'Scope labels not resolved.'
        Assert ($properties.dimensionSettings.dataResidency.parameters.allowedLocations[0] -eq 'swedencentral' -and $properties.policyInitiatives.Count -eq 6) 'Handoff settings/associations mismatch.'
        foreach ($a in $manifest.assignments) {
            Assert ((($a.id -split '/')[-1]).Length -le 24) 'MG assignment name is too long.'
            Assert ($a.body.properties.enforcementMode -eq 'DoNotEnforce' -and -not $a.body.Contains('identity')) 'Unexpected enforcement or identity.'
            $initiative = $a.body.properties.policyDefinitionId
            if ($initiative.EndsWith($ear)) {
                Assert ($a.body.properties.parameters.effect.value -eq 'Audit' -and $a.body.properties.parameters.enabled.value -eq $true -and $a.body.properties.definitionVersion -eq '1.1.*-preview') 'Overrides or version pin failed.'
            } else {
                Assert ($a.body.properties.parameters.effect.value -eq 'Deny') 'Definition default was silently changed.'
            }
        }
        Assert (@($mock.calls | Where-Object { $_.method -eq 'PUT' -and $_.uri -notmatch '/policyAssignments/' }).Count -eq 0) 'Helper wrote something other than policy assignments.'
        $callsBefore = $mock.calls.Count
        Reject $script $arguments 'OutputDirectory must be new'
        Assert ($mock.calls.Count -eq $callsBefore) 'Existing output should fail before cloud calls.'

        Reset-Mock
        $basic = @{ ExpectedTenantId = $tenant; SovereignViewName = 'example-view'; SubscriptionIds = @($subscription); OutputDirectory = (Join-Path $temp "$prefix-preview"); AllowedLocations = @('swedencentral') }
        $preview = & $script @basic -WhatIf
        Assert ($preview.status -eq 'Preview' -and $preview.assignments.Count -eq 2 -and $mock.putCount -eq 0 -and -not(Test-Path $basic.OutputDirectory)) 'WhatIf must not write assignments or output files.'
        $basic.ResourceEvaluationScope = 'ResourceOnly'
        $preview = & $script @basic -WhatIf
        Assert ($preview.assignments.Count -eq 1) 'ResourceOnly should not create R360.'

        Reset-Mock
        $missing = $basic.Clone(); $missing.Remove('AllowedLocations')
        Reject $script $missing 'has no default'
        Assert ($mock.putCount -eq 0) 'Missing required parameter must fail before writes.'
        Reset-Mock
        $mock.collision = $true
        Reject $script $basic 'returned 200'
        Assert ($mock.putCount -eq 0) 'Existing PA must never be overwritten.'
        Reset-Mock
        $mock.wrongTenant = $true
        Reject $script $basic 'tenant/name'
        Assert ($mock.putCount -eq 0) 'Cross-tenant scope must fail before writes.'
        Reset-Mock
        $bad = Join-Path $temp "$prefix-bad-overrides.json"
        @(@{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$dr"; assignmentParameters = @{ effect = @{ value = 'NotAnEffect' } } }) |
            ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $bad
        $badArgs = $basic.Clone(); $badArgs.OverridesPath = $bad
        Reject $script $badArgs 'outside allowedValues'
        Assert ($mock.putCount -eq 0) 'Invalid values must fail before writes.'
        Reset-Mock
        @(@{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$dr"; assignmentParameters = @{ listOfAllowedLocations = @{ value = @('northeurope') } } }) |
            ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $bad
        Reject $script $badArgs 'Specify allowed locations once'
        Assert ($mock.putCount -eq 0) 'Ambiguous location overrides must fail before writes.'
        Reset-Mock
        $duplicate = $basic.Clone(); $duplicate.SubscriptionIds = @($subscription, $subscription)
        Reject $script $duplicate 'Duplicate scopes'
        Assert ($mock.putCount -eq 0) 'Duplicate scopes must fail before writes.'
        Reset-Mock
        @(@{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$dr"; assignmentParameters = @{ unexpected = @{ value = 'anything' } } }) |
            ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $bad
        Reject $script $badArgs 'Unknown parameter'
        Assert ($mock.putCount -eq 0) 'Unknown parameters must fail before writes.'
        Reset-Mock
        @(@{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$dr"; assignmentParameters = @{ listOfAllowedLocations = @{ value = 'swedencentral' } } }) |
            ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $bad
        $typeArgs = $badArgs.Clone(); $typeArgs.Remove('AllowedLocations')
        Reject $script $typeArgs 'Invalid value type'
        Assert ($mock.putCount -eq 0) 'Incorrect required-value types must fail before writes.'
        Reset-Mock
        @(
            @{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$dr"; assignmentParameters = @{ listOfAllowedLocations = @{ value = @('swedencentral') } } },
            @{ policyInitiativeId = "/providers/Microsoft.Authorization/policySetDefinitions/$r360"; assignmentParameters = @{ listOfAllowedLocations = @{ value = @('northeurope') } } }
        ) | ConvertTo-Json -Depth 20 -AsArray | Set-Content -LiteralPath $bad
        $locationArgs = $typeArgs.Clone(); $locationArgs.Remove('ResourceEvaluationScope')
        Reject $script $locationArgs 'must use the same allowed locations'
        Assert ($mock.putCount -eq 0) 'Inconsistent DR/R360 settings must fail before writes.'
        Reset-Mock
        $mock.remediationDefault = $true
        Reject $script $basic 'requires an assignment identity'
        Assert ($mock.putCount -eq 0) 'Identity-requiring effective effects must fail during planning, not after partial writes.'

        Reset-Mock
        $partial = $basic.Clone(); $partial.Remove('ResourceEvaluationScope'); $partial.OutputDirectory = Join-Path $temp "$prefix-partial"
        $mock.failPut = 2
        Reject $script $partial 'returned 403'
        $m = Get-Content -Raw (Join-Path $partial.OutputDirectory 'manifest.json') | ConvertFrom-Json -AsHashtable
        Assert ($m.status -eq 'Failed' -and $m.assignments[0].status -eq 'Created' -and $m.assignments[1].status -eq 'Creating') 'Partial state must retain created and uncertain IDs.'
        Assert ($mock.putCount -eq 2 -and $mock.calls[-1].method -eq 'PUT' -and -not(Test-Path (Join-Path $partial.OutputDirectory 'view.parameters.json'))) 'Failure must stop without publishing a deploy-ready file or auto-cleanup.'
        Reset-Mock
        $verification = $basic.Clone(); $verification.OutputDirectory = Join-Path $temp "$prefix-verification"
        $mock.badVerification = $true
        Reject $script $verification 'verification failed'
        Assert ($mock.putCount -eq 1) 'Verification error must stop subsequent writes.'
    }
    Write-Output "Passed $script:checks assertions for the policy-assignment helper. No Azure calls were made."
}
finally {
    Remove-Item -LiteralPath $temp -Recurse -Force
}
