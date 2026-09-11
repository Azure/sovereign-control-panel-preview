# Self-serve subscription registration

Use this guide to register a subscription for SovereignView when the feature is available in the Azure portal. The feature and the `Microsoft.Sovereign` resource provider must both be registered before you retry the SovereignView create request.

## Register the subscription in the Azure portal

1. Open the [Azure portal](https://portal.azure.com).
2. Search for **Subscriptions** and open the subscription where the SovereignView will be created.
3. In the subscription menu, open **Settings** > **Preview features**.
4. Search for **SovereignView**.
5. Select the feature and choose **Register**.
6. Refresh the page until the state is **Registered**.
7. In the same subscription, open **Settings** > **Resource providers**.
8. Search for **Microsoft.Sovereign**.
9. Confirm that its registration state is **Registered**. If necessary, select the provider and choose **Register**.
10. Retry the SovereignView create request after the feature and provider both show the expected state.

## Register the subscription with Azure CLI

If SovereignView is not visible under **Preview features**, use Azure CLI:

```bash
az account set --subscription "<subscription-id>"
az feature register --namespace Microsoft.Sovereign --name SovereignView
az feature show --namespace Microsoft.Sovereign --name SovereignView \
  --query properties.state --output tsv
az provider register --namespace Microsoft.Sovereign
az provider show --namespace Microsoft.Sovereign \
  --query registrationState --output tsv
```

Refresh the feature and provider status until both commands report `Registered`, then retry the SovereignView create request.

## Next steps

- [Register the resource provider](02-register-resource-provider.md)
- [Create a Sovereign View](03-create-sovereign-view.md)
