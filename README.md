# Sovereign Control Panel Private Preview

Sovereign Control Panel (SCP) is a unified Azure portal experience for viewing, managing, and evaluating sovereignty posture across tenant resources. It aggregates sovereignty signals into a centralised, and intuitive console for end users, and reviewers to view and verify sovereignty requirements.

This repository contains the onboarding documentation for the SCP Private Preview.

> [!IMPORTANT]
> Sovereign Control Panel is currently in an **invite-only**  

## What SCP does in Private Preview

Private Preview focuses on the **View Experience** — the ability to create and view Sovereign control across your Azure resources. In this phase, SCP is **read-only**. It does not update or auto remediate cloud resources, making it a safe, observational tool for monitoring. It emphasizes posture visibility, helping you monitor existing Azure resources for sovereign control signals without changing them.

With SCP, you can:

- View your sovereignty and compliance posture across subscriptions and management groups in one place.
- Create **Sovereign Views** that scope an evaluation to the resources and control signals you care about.
- Drill down from a high-level posture summary to the specific resource that is flagged, and understand why.


## Key concept: Sovereign view

A **Sovereign view (Preview)** is a new Azure resource type used to define what you want to monitor for sovereignty control. Creating a Sovereign view lets you select:

- A **scope** of Azure resources — for example, a single subscription, a group of subscriptions, or a management group hierarchy.
- A set of **sovereign control signals** (policy-based initiatives, data encryption) to assess.

The result is a tailored compliance view for that scope, surfaced in the Azure portal.

<img width="2109" height="1970" alt="Screenshot 2026-06-24 124125" src="https://github.com/user-attachments/assets/ea5ad72c-db68-43a6-9a11-e68ffcb33561" />

## Features

| Feature | Description |
| ------- | ----------- |
|Centralised Experience| Aggregate sovereignty controls and signals across your Azure estate into one unified posture view. |
| Sovereign Views | Define reusable, scoped evaluations by subscription, management group, and selected control signals. |
| Drill-down and explainability | Move from high-level posture to the specific non-compliant resource, with reasoning on why it's flagged. |

## Who should use SCP

SCP is intended for organizations that are on Azure  and need to demonstrate strong alignment with local laws, policy frameworks while continuing to benefit from public-cloud innovation, resiliency, and security. 

Typical users of SCP include organizations that want to host some, or most of their workloads and resources in accordance with regulatory requirements, e.g., [SEAL framework](https://commission.europa.eu/document/download/09579818-64a6-4dd5-9577-446ab6219113_en). 

 - These can be national and federal government and public sector agencies.  

 - Regulated industries such as financial, healthcare, defense, energy, and critical infrastructure services. 

 - National and sovereign cloud operators 

The current Private Preview is invite-only and targets brownfield customers with existing Azure estates.

## Prerequisites

Before you begin onboarding, make sure you have:

- Azure tenant id along with the subscription id(s)  shared via onboarding form
- Sufficient Azure RBAC access to create the view and configure the required scope as mentioned in [Prerequisites and roles](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/how-to/01-prerequisites-and-roles.md)

## Onboarding

Follow these how-to modules to set up your first Sovereign View and start seeing results. See the [documentation hub](/docs/README.md) for the full set of guides.

| Module | Description |
| ------ | ----------- |
| [Module 1: Prerequisites and roles](/docs/how-to/01-prerequisites-and-roles.md) | Confirm preview access and the Azure RBAC roles required for each onboarding action. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `Microsoft.Sovereign` resource provider in your subscription. |
| [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource and select its scope and policy initiative. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader and Resource Policy Contributor across the in-scope subscriptions. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Read and interpret your report and manage the resource over time. |
| [Module 6: Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md) | Remove a Sovereign View resource and understand what deletion affects. |
| [Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

## Scenarios and capabilities

In this Private Preview we support the following scenarios:

 - **Sovereignty posture monitoring**. A "show me where I stand" view across data residency, encryption, network isolation — built from aggregated signals, not policy coverage alone. 

 - **Evaluating multi-resource controls.** Get a verdict on controls like Customer-Managed Keys or private endpoints, where correctness depends on several resources together. 

## Support and feedback

We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **Azscp@microsoft.com** or raised directly with the team via Team Channel. We also accept bugs and feedback filed through [GitHub Issues](../../issues).

> [!NOTE]
> Do not report security vulnerabilities through public GitHub issues. See [SECURITY.md](SECURITY.md) for reporting guidance.

## Additional resources

- [Documentation hub](/docs/README.md)
- [Glossary](/docs/reference/glossary.md)
- [What is Microsoft Sovereign Cloud?](https://learn.microsoft.com/azure/azure-sovereign-clouds/microsoft-sovereign-cloud)
- [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/)
