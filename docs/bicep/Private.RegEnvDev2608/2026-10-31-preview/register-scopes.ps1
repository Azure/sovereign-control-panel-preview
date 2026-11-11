param(
    [string[]] $SubscriptionIds = @(),
    [string[]] $ManagementGroupIds = @()
)

$ErrorActionPreference = 'Stop'
$provider = 'Private.RegEnvDev2608'
$armEndpoint = 'https://eastus2euap.management.azure.com'
$apiVersion = '2021-04-01'

foreach ($subscriptionId in $SubscriptionIds) {
    Write-Host "Registering $provider on subscription $subscriptionId ..."
    $providerUri = "$armEndpoint/subscriptions/$subscriptionId/providers/$provider"
    az rest --method post `
        --url "${providerUri}/register?api-version=$apiVersion" `
        --resource https://management.azure.com/ `
        --subscription $subscriptionId `
        --output none `
        --only-show-errors
    if ($LASTEXITCODE -ne 0) { throw "Provider registration failed for subscription $subscriptionId." }

    $deadline = [DateTimeOffset]::UtcNow.AddMinutes(5)
    do {
        $state = az rest --method get `
            --url "${providerUri}?api-version=$apiVersion" `
            --resource https://management.azure.com/ `
            --subscription $subscriptionId `
            --query registrationState `
            --output tsv `
            --only-show-errors
        if ($LASTEXITCODE -ne 0) { throw "Registration status could not be read for subscription $subscriptionId." }
        if ($state -eq 'Registered') { break }
        if ([DateTimeOffset]::UtcNow -ge $deadline) { throw "Provider registration did not finish for subscription $subscriptionId." }
        Start-Sleep -Seconds 5
    } while ($true)

    Write-Host "  -> $state"
}

foreach ($managementGroupId in $ManagementGroupIds) {
    Write-Host "Registering $provider on management group $managementGroupId ..."
    $groupName = [uri]::EscapeDataString($managementGroupId.TrimEnd('/').Split('/')[-1])
    az rest --method post `
        --url "$armEndpoint/providers/Microsoft.Management/managementGroups/$groupName/providers/$provider/register?api-version=$apiVersion" `
        --resource https://management.azure.com/ `
        --output none `
        --only-show-errors
    if ($LASTEXITCODE -ne 0) { throw "Provider registration failed for management group $managementGroupId." }

    Write-Host '  -> registration requested; management-group registration is asynchronous.'
}

Write-Host 'Registration requests complete.'
