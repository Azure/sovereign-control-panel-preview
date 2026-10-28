# Documentation

This repository includes how-to guides and reference content for onboarding to the Sovereign Control Panel (SCP) Private Preview.

Sovereign Control Panel (SCP) is a new Azure portal capability that helps organizations meet their sovereign control requirements. It provides a single, unified sovereignty control posture across data residency, encryption, and controlled network exposure. With SCP, you create a **Sovereign View** — a consolidated sovereignty posture across the Azure subscriptions or management groups you choose.

> [!IMPORTANT]
> Sovereign Control Panel is in an invite-only **Private Preview**. 

## How-to guides

Use these modules to complete an end-to-end onboarding: register the resource provider, create a Sovereign View, grant the managed identity access, and read your sovereignty control report.

| Module | Description |
| ------ | ----------- |
| [Module 1: Prerequisites and roles](/docs/how-to/01-roles%20and%20permissions.md) | Confirm preview access and the Azure RBAC roles required for each onboarding action. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `SovereignView` preview feature and `Microsoft.Sovereign` resource provider from the Azure portal or Azure CLI. |
| [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource, select its scope, and optionally enable the Encryption in transit (TLS) initiative. |
| [Module 3 alternative: Deploy with Bicep](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md) | Use the included Bicep package for a repeatable, reviewable Sovereign View deployment. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader and Resource Policy Contributor across the in-scope subscriptions, manually or by script. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Review dimension summaries and resource-level compliance, including Encryption in transit results. |
| [Module 6: Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md) | Remove a Sovereign View resource and understand what deletion affects. |
| [Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

## Reference

| Article | Description |
| ------- | ----------- |
| [Glossary](/docs/reference/glossary.md) | Definitions of key sovereignty and Azure terms used throughout this guide. |
| [Bicep deployment package](/docs/bicep) | Downloadable templates, customer parameters, role modules, and resource-provider registration helper. |

## Support and feedback

We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **Azscp@microsoft.com** or raised directly with your Microsoft contacts.
