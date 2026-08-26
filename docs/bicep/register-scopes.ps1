param(
    [string[]] $SubscriptionIds = @(),
    [string[]] $ManagementGroupIds = @()
)

$ErrorActionPreference = 'Stop'
$provider = 'Microsoft.Sovereign'

foreach ($subscriptionId in $SubscriptionIds) {
    Write-Host "Registering $provider on subscription $subscriptionId ..."
    az provider register `
        --namespace $provider `
        --subscription $subscriptionId `
        --wait `
        --only-show-errors

    $state = az provider show `
        --namespace $provider `
        --subscription $subscriptionId `
        --query registrationState `
        --output tsv

    Write-Host "  -> $state"
}

foreach ($managementGroupId in $ManagementGroupIds) {
    Write-Host "Registering $provider on management group $managementGroupId ..."
    az provider register `
        --namespace $provider `
        --management-group-id $managementGroupId `
        --only-show-errors

    Write-Host '  -> registration requested; management-group registration is asynchronous.'
}

Write-Host 'Registration requests complete.'