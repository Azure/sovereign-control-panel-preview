# View the sovereignty control report

Use this module to review the Sovereign View report after data collection completes, including dimension-level summaries and resource-level compliance details.

## Prerequisites

- Complete [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md).
- Allow up to 24 hours after the role assignments for the initial scan to complete.

## Read the report

After data collection is complete, your Sovereign View resource presents a sovereignty control report in the Azure portal.

<img src="../assets/img-40.jpg" width="900" alt="Sovereignty control report in the Azure portal." />

| Area | What you see | Screenshot |
| --- | --- | --- |
| **Resource compliance list** | From the **Encryption in transit** card, select **View resources out of policy**. The resources page opens with the **Encryption in Transit** filter applied so you can review resource-level compliance. | <img src="../assets/img-41.jpg" width="900" alt="Resources filtered to show Encryption in Transit results that are out of policy." /> |
| **Policy details** | Select a resource to open the details pane. Review the **Encryption in Transit** result and Azure Policy information to understand the gap and plan remediation. | <img src="../assets/img-42.jpg" width="900" alt="Resource details pane showing policy information for an Encryption in Transit result." /> |

## Manage the resource

The Sovereign View resource periodically refreshes its data (for example, every 24 hours, or as policies trigger scans). You don't need to re-run anything manually — check the resource page for updated sovereign control status over time.

## Next steps

- [Remediate Data Residency issues](/docs/how-to/08-remediate-data-residency.md)
- [Delete a Sovereign View](/docs/how-to/06-delete-sovereign-view.md)
- [Troubleshooting and support](/docs/how-to/07-troubleshooting-and-support.md)
