# Regulatory documents

Regulatory Documents help you create a Sovereign View with a curated selection of sovereign controls relevant to a regulation. Instead of starting only from individual policy initiatives, you select a document and review the controls available for that selection.

The selected document determines which controls are available in the create experience. You still choose the subscriptions or management groups to assess and configure the supported controls. SCP uses those controls to report the technical configuration posture of resources in your scope.

> [!IMPORTANT]
> Support for a regulatory document means that SCP provides selected technical controls relevant to it. It does not mean that SCP evaluates every requirement, certifies compliance, or provides legal advice. Review the source document and your organization's obligations separately.

## Supported documents and baseline

The Private Preview catalog includes the following selections. Availability depends on your preview rollout and the region selected for the Sovereign View.

| Selection in the portal | What it represents | Source |
| --- | --- | --- |
| **Azure cloud sovereign baseline** | The general sovereignty-control baseline offered by SCP. This is the default selection in the portal, not a separate regulation. | [Microsoft Sovereign Cloud documentation](https://learn.microsoft.com/en-us/industry/sovereignty/) |
| **Digital Operational Resilience Act (DORA)** | Regulation (EU) 2022/2554 on digital operational resilience for the financial sector. | [Read DORA](https://publications.europa.eu/resource/celex/32022R2554) |
| **Network and Information Security Directive 2 (NIS2)** | Directive (EU) 2022/2555 on measures for a high common level of cybersecurity across the European Union. | [Read the NIS2 Directive](https://publications.europa.eu/resource/celex/32022L2555) |

## Select a document when creating a view

1. Start [Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md) and complete the **Basics** and **Scope** steps.
2. On the **Sovereign controls** tab, use **Select regulation** to choose the baseline, DORA, or NIS2 from the available options.
3. Review the supported controls, select the controls you want to assess, and configure their parameters.
4. For DORA and NIS2, also review **Unsupported regulations** and any **Action available** links before continuing.
5. On **Review + create**, confirm the **Selected regulation**, policy initiatives, and scope before creating the view.
6. Complete the [managed identity role assignments](/docs/how-to/04-assign-managed-identity-roles.md), then [view the sovereignty control report](/docs/how-to/05-view-compliance-report.md).

> [!NOTE]
> If **Select regulation** is not shown, the regulatory-document experience might not yet be enabled for your preview. You can continue with the existing policy-initiative create experience or contact the [preview support team](/docs/how-to/07-troubleshooting-and-support.md#get-help-or-give-feedback).

Choose the document when you create the view. To assess a different document, create a separate Sovereign View with that selection.

## Understand the coverage

For DORA and NIS2, the create experience separates:

- **Supported regulations**: The controls available for the selected document. These controls contribute technical signals to the Sovereign View report.
- **Unsupported regulations**: Requirements or control areas that the current SCP selection does not evaluate. Review these gaps alongside the source document. An **Action available** link provides guidance; following the link does not automatically add an assessment to the view.

The baseline selection shows the general sovereign controls rather than the document-specific supported and unsupported sections.

In Private Preview, policy assignments used for these assessments are non-enforcing. Selecting a regulatory document does not change application resources or automatically remediate findings. A successful view deployment or a compliant technical-control result is not evidence that all requirements of the document have been met.

## Related guides

- [Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md)
- [View the sovereignty control report](/docs/how-to/05-view-compliance-report.md)
- [Preview limitations and support](/docs/how-to/07-troubleshooting-and-support.md)
