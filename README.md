# Sovereign Control Panel Private Preview

Sovereign Control Panel (SCP) is a unified Azure portal experience for viewing, managing, and evaluating sovereignty posture across tenant resources. It aggregates sovereignty signals into a centralised, and intuitive console for end users, and reviewers to view and verify sovereignty requirements.

This repository contains the onboarding documentation for the SCP Private Preview.

> [!IMPORTANT]
> Sovereign Control Panel is currently in an **invite-only**  

## What SCP does in Private Preview

Private Preview focuses on the **View Experience** — the ability to create and view Sovereign control across your Azure resources. In this phase, SCP is **read-only**. It does not update or auto remediate cloud resources, making it a safe, observational tool for monitoring. It emphasizes posture visibility, helping you monitor existing Azure resources for sovereign control signals without changing them.

## Prerequisites

Before you begin onboarding, make sure you have:

- Azure tenant id along with the subscription id(s)  shared via onboarding form
- Sufficient Azure RBAC access to create the view and configure the required scope as mentioned in [Prerequisites and roles](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/how-to/01-prerequisites-and-roles.md)

## Onboarding

Follow these how-to modules to set up your first Sovereign view. See the [documentation hub](/docs/README.md) for the full set of guides.

| Module | Description |
| ------ | ----------- |
| [Module 1: Prerequisites and roles](/docs/how-to/01-prerequisites-and-roles.md) | Confirm preview access and the Azure RBAC roles required for each onboarding action. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `Microsoft.Sovereign` resource provider in your subscription. |
| [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource and select its scope and policy initiative. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader and Resource Policy Contributor across the in-scope subscriptions. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Read and interpret your report and manage the resource over time. |
| [Module 6: Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md) | Remove a Sovereign View resource and understand what deletion affects. |
| [Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

## Support and feedback
We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **(Azscp@microsoft.com)** or raised directly with your Microsoft contacts.

> [!NOTE]
> Do not report security vulnerabilities through public GitHub issues. See [SECURITY.md](SECURITY.md) for reporting guidance.

## Additional resources

- [[Learn More](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/Learn%20More.md)]
- [Documentation hub](/docs/README.md)
- [Glossary](/docs/reference/glossary.md)
- [What is Microsoft Sovereign Cloud?](https://learn.microsoft.com/azure/azure-sovereign-clouds/microsoft-sovereign-cloud)
- [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/)
