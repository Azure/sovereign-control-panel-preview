# Sovereign Control Panel Private Preview

Sovereign Control Panel (SCP) is a unified Azure portal experience for viewing, managing, evaluating and remediate (data residency) sovereignty posture across tenant resources. It aggregates sovereignty signals into a centralized experience so you can understand configuration posture across subscriptions and workloads.

This repository contains the onboarding documentation for the SCP Private Preview.

> [!IMPORTANT]
> Sovereign Control Panel is currently in an **invite-only**  

## What SCP does in Private Preview

The **View Experience** lets you create and view Sovereign control across your Azure resources. Evaluations are non-enforcing and do not automatically remediate resources. For eligible Data Residency findings, you can explicitly initiate remediation, review and deploy a generated ARM template, and then complete the resource move in Azure Resource Mover.

## Prerequisites

Before you begin onboarding, make sure you have:

- Azure tenant id along with the subscription id(s) shared via [onboarding form](https://forms.office.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR9kfDOroV5ZOpVqvGBArQP5UQVlIQ1I3UTNYOUpLNExHQ0RYQ1AwU0dMTzVaRi4u)
- Sufficient Azure RBAC access to create the view and configure the required scope as mentioned in [roles and permission](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/how-to/01-prerequisites-and-roles.md)

## How to get started

Use **Create a view** to assess the sovereignty posture of existing Azure resources. To deploy an environment with sovereignty controls and governance, open the **Get started** tab and select **Learn more** under **Sovereign Landing Zone**.

<details open>
<summary><h3>Create Sovereign View using Azure Portal (UI)</h3></summary>

Follow these how-to modules to set up your first Sovereign view using Azure Portal (UI). See the [documentation hub](/docs/README.md) for the full set of guides.

| Module | Description |
| ------ | ----------- |
| [Module 1: Roles and Permissions](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/how-to/01-roles%20and%20permissions.md#roles-and-permissions) | Confirm preview eligibility, capture required tenant and subscription IDs, and make sure you hold the Azure RBAC roles needed for setup. |
| [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md) | Register the `SovereignView` preview feature and `Microsoft.Sovereign` resource provider from the Azure portal or Azure CLI. |
| [Module 3: Create a Sovereign view](/docs/how-to/03-create-sovereign-view.md) | Create a Sovereign View resource, select its scope, and optionally enable the Encryption in transit (TLS) initiative. |
| [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md) | Grant the view's managed identity Reader across the in-scope subscriptions and any management groups you selected. |
| [Module 5: View the sovereignty control report](/docs/how-to/05-view-compliance-report.md) | Review dimension summaries and resource-level compliance, including Encryption in transit results. |
| [Module 6: Delete a Sovereign view](/docs/how-to/06-delete-sovereign-view.md) | Remove a Sovereign View resource and understand what deletion affects. |
| [Module 7: Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md) | Resolve common onboarding issues, review preview limitations, and get help. |

</details>

<details open>
<summary><h3>Create Sovereign View using Bicep</h3></summary>

Use the Bicep deployment guide to create a Sovereign View with a repeatable,
reviewable Infrastructure-as-Code workflow.

| Module | Description |
| ------ | ----------- |
| [Deploy a Sovereign View with Bicep](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md) | Configure, preview, deploy, and validate a Sovereign View across subscription and management-group scopes. |

</details>

<details open>
<summary><h3>Remediation - Data Residency</h3></summary>

Use the remediation guide to address eligible out-of-region resources. Review permissions and supported resource types, configure the destination, and download or deploy the generated ARM template. Template deployment sets up Azure Resource Mover; it does not complete the move or immediately update compliance.

| Module | Description |
| ------ | ----------- |
| [Remediate Data Residency issues](/docs/how-to/08-remediate-data-residency.md) | Identify a finding, configure and deploy the remediation setup, complete the move in Azure Resource Mover, and verify residency after the next policy evaluation cycle. |

</details>

## Azure Resource Graph (ARG) queries

Sovereign Control Panel uses Azure Resource Graph queries, written in Kusto Query Language (KQL), to evaluate resource compliance posture across a Sovereign View scope. The [ARG queries guide](/arg-queries/README.md) introduces the query files so you can inspect the logic behind ARG-based compliance evaluation results.

When a compliance evaluation result in the Azure portal references an ARG query, select **View query** to open the corresponding versioned `.kql` file in this repository.

## Support and feedback
We prefer support requests, feedback, and bugs for the Private Preview features to be emailed to **(Azscp@microsoft.com)** or raised directly with your Microsoft contacts.

See [SUPPORT.md](SUPPORT.md) for support channels and the Microsoft Support Policy.

> [!NOTE]
> Do not report security vulnerabilities through public GitHub issues. See [SECURITY.md](SECURITY.md) for reporting guidance.

## Additional resources

- [[Learn More](https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/Learn%20More.md)]
- [Documentation hub](/docs/README.md)
- [Glossary](/docs/reference/glossary.md)
- [What is Microsoft Sovereign Cloud?](https://learn.microsoft.com/azure/azure-sovereign-clouds/microsoft-sovereign-cloud)
- [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/)
## Trademark Notice

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft's Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
