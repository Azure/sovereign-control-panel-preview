# Sovereign Control Panel

Sovereign Control Panel (SCP) provides a unified experience in the Azure portal to assess and manage sovereignty posture across Azure resources. It brings sovereignty insights together to help organizations understand their posture, apply controls, and prioritize action.

Sovereign Control Panel is in **public preview**. Learn more in the [Sovereign Control Panel overview on Microsoft Learn](https://learn.microsoft.com/azure/azure-sovereign-clouds/public/sovereign-control-panel).

## Create a Sovereign View using Bicep

Choose an explicit API-version package from the [Bicep version catalog](/docs/bicep/README.md)
for a repeatable, reviewable Infrastructure-as-Code workflow. Confirm that the
service supports the selected contract before deploying.

| Deployment guide | Description |
| ------ | ----------- |
| [Deploy with Bicep: 2026-10-31-preview](/docs/how-to/03c-deploy-sovereign-view-with-bicep-2026-10-31-preview.md) | Select dimensions, create dedicated policy assignments with defaults or overrides, and deploy using their IDs. Requires service support for the published contract. |
| [Legacy Bicep: 2026-03-15-preview](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md) | Use the legacy assignment-parameter workflow and role modules in Sweden Central. |

## Azure Resource Graph (ARG) queries

Sovereign Control Panel uses Azure Resource Graph queries, written in Kusto Query Language (KQL), to evaluate resource compliance posture across a Sovereign View scope. The [ARG queries guide](/arg-queries/README.md) introduces the query files so you can inspect the logic behind ARG-based compliance evaluation results.

When a compliance evaluation result in the Azure portal references an ARG query, select **View query** to open the corresponding versioned `.kql` file in this repository.

## Contributions

This repository is maintained exclusively by the internal SCP team (`@Azure/scp-team`). External contributions, including pull requests, are not accepted. See [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution policy.

## Support and feedback
We prefer support requests, feedback, and bugs for the public preview features to be emailed to **(Azscp@microsoft.com)** or raised directly with your Microsoft contacts.

> [!NOTE]
> Do not report security vulnerabilities through public GitHub issues. See [SECURITY.md](SECURITY.md) for reporting guidance.

## Additional resources

- [What is Microsoft Sovereign Cloud?](https://learn.microsoft.com/azure/azure-sovereign-clouds/microsoft-sovereign-cloud)
- [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/)
## Trademark Notice

Trademarks This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow Microsoft's Trademark & Brand Guidelines. Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.

