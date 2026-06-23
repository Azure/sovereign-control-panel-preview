# Sovereign Control Panel Private Preview

Sovereign Control Panel (SCP) is a new Azure sovereignty posture control center that gives organizations transparency, control, and confidence as they work to meet their sovereignty and compliance requirements. It offers a single unified view — a "single pane of glass" — showing where your organization stands on data sovereignty and regulatory compliance across your Azure estate.

This repository contains the onboarding documentation for the SCP Private Preview.

> [!IMPORTANT]
> Sovereign Control Panel is currently in an **invite-only Private Preview**. Access requires an executed agreement with Microsoft. Features, APIs, and experiences described here may change before general availability and are subject to the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## What SCP does in Private Preview

Private Preview focuses on the **View Experience** — the ability to create and view Sovereign Compliance "Views" across your Azure environment. In this phase, SCP is **read-only**: it does not create or modify cloud resources, making it a safe, observational tool for compliance monitoring. It emphasizes posture visibility, helping you monitor existing Azure resources ("brownfield" environments) for compliance signals without changing them.

With SCP, you can:

- View your sovereignty and compliance posture across subscriptions and management groups in one place.
- Create **Sovereign Views** that scope an evaluation to the resources and control signals you care about.
- Drill down from a high-level posture summary to the specific resource that is flagged, and understand why.
- Generate audit-ready posture reports for internal stakeholders, auditors, and regulators.

## Key concept: Sovereign View

A **Sovereign View (Preview)** is a new Azure resource type used to define what you want to monitor for sovereignty compliance. Creating a Sovereign View lets you select:

- A **scope** of Azure resources — for example, a single subscription, a group of subscriptions, or a management group hierarchy.
- A set of **sovereign control signals** (policy-based initiatives) to assess.

The result is a tailored compliance view for that scope, surfaced in the Azure portal.

## Features

| Feature | Description |
| ------- | ----------- |
| Single pane of glass | Aggregate sovereignty and compliance signals across your Azure estate into one unified posture view. |
| Sovereign Views | Define reusable, scoped evaluations by subscription, management group, and selected control signals. |
| Read-only posture monitoring | Observe brownfield environments safely — the preview makes no changes to your cloud resources. |
| Drill-down and explainability | Move from high-level posture to the specific non-compliant resource, with reasoning on why it's flagged. |
| Audit-ready reporting | Export posture and compliance reports suitable for internal audit and regulator review. |
| RBAC-aware experience | Posture data is scoped to the signed-in user's Azure permissions. |

## Who should use SCP

SCP is intended for governments and regulated industries that need to demonstrate alignment with local laws, policies, and regulatory frameworks while continuing to benefit from public-cloud innovation. Typical roles include:

- **Tenant administrators** — overall accountability for sovereignty posture.
- **Management group and subscription owners** — governance, monitoring, and remediation.
- **Compliance, risk, and security leaders** — executive-level posture and trend reporting.
- **Auditors and regulators** — read-only posture access and reporting.

The current Private Preview is invite-only and targets brownfield customers with existing Azure estates.

## Prerequisites

Before you begin onboarding, make sure you have:

- An Azure subscription, with the appropriate permissions on the scope you want to evaluate.
- One or more subscriptions or a management group hierarchy that you want to bring into a Sovereign View.
- An accepted invitation to the SCP Private Preview and any required feature flags enabled on your tenant.
- Network connectivity to the Azure portal.

## Onboarding

Follow these how-to modules to set up your first Sovereign View and start seeing results. See the [documentation hub](/docs/README.md) for the full set of guides.

| Module | Description |
| ------ | ----------- |
| [Module 1: Prerequisites and roles](/docs/how-to/01-prerequisites-and-roles.md) | Confirm preview access and the Azure RBAC roles required for each onboarding action. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `Microsoft.Sovereign` resource provider in your subscription. |
| [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource and select its scope and policy initiative. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader and Resource Policy Contributor across the in-scope subscriptions. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Read and interpret your report, manage the resource, and delete it. |
| [Module 6: Troubleshooting and support](/docs/how-to/06-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

## Scenarios and capabilities

In this Private Preview we support the following scenarios:

- **Sovereignty posture monitoring** — a read-only "show me where I stand" experience across data residency, encryption, network isolation, and policy compliance.
- **Regulated compliance and audit** — prove which controls are applied and generate audit-ready exports for regulators and internal auditors.
- **Brownfield customer onboarding** — bring existing subscriptions and management groups and evaluate posture without re-architecting your estate.

## Support and feedback

We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **XXXXXX** or raised directly with your Microsoft contacts. We also accept bugs and feedback filed through [GitHub Issues](../../issues).

> [!NOTE]
> Do not report security vulnerabilities through public GitHub issues. See [SECURITY.md](SECURITY.md) for reporting guidance.

## Additional resources

- [Documentation hub](/docs/README.md)
- [Glossary](/docs/reference/glossary.md)
- [What is Microsoft Sovereign Cloud?](https://learn.microsoft.com/azure/azure-sovereign-clouds/microsoft-sovereign-cloud)
- [Sovereign Landing Zone overview](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/overview-sovereign-landing-zone)
- [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/)
