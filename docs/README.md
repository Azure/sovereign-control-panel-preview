# Documentation

This repository includes how-to guides and reference content for onboarding to the Sovereign Control Panel (SCP) Private Preview.

Sovereign Control Panel (SCP) is a new Azure portal capability that helps organizations meet their sovereign control requirements. It provides a single, unified sovereignty control posture across data residency, encryption, and controlled network exposure. With SCP, you create a **Sovereign View** — a consolidated sovereignty posture across the Azure subscriptions or management groups you choose.

> [!IMPORTANT]
> Sovereign Control Panel is in an invite-only **Private Preview**. 

## How-to guides

Use these modules to complete an end-to-end onboarding: register the resource provider, create a Sovereign View, grant the managed identity access, and read your sovereignty control report.

| Module | Description |
| ------ | ----------- |
| [Module 1: Prerequisites and roles](/docs/how-to/01-prerequisites-and-roles.md) | Confirm preview access and the Azure RBAC roles required for each onboarding action. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `Microsoft.Sovereign` resource provider in your subscription. |
| [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource and select its scope and policy initiative. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader and Resource Policy Contributor across the in-scope subscriptions, manually or by script. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Read and interpret your report and manage the resource over time. |
| [Module 6: Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md) | Remove a Sovereign View resource and understand what deletion affects. |
| [Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

## Reference

| Article | Description |
| ------- | ----------- |
| [Glossary](/docs/reference/glossary.md) | Definitions of key sovereignty and Azure terms used throughout this guide. |

## Support and feedback

We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **Azscp@microsoft.com** or raised directly with your Microsoft contacts.
