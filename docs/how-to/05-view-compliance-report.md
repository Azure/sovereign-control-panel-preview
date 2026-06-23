# View the sovereignty control report

After data collection is complete, your Sovereign View resource presents a sovereignty control report in the Azure portal. This guide explains how to read the report and how to manage and delete the resource over time.

## Prerequisites

- Complete [Module 4: Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md).
- Allow up to 24 hours after the role assignments for the initial scan to complete.

## Read the report

- **Report dashboard**: Navigate to your Sovereign View resource in the Azure portal. The **Overview** tab displays a summary of results. You typically see the overall status of the selected scope, with a breakdown by control category (such as data residency or encryption).

- **Reasoning and definitions**: For each control or policy listed, you can drill down for more information about what it checks. Definitions are available on the Azure Policy definition page in the portal. For this preview, the definitions correspond to sovereignty best practices such as encryption and data location restrictions.

## Manage the resource

The Sovereign View resource periodically refreshes its data (for example, every 24 hours, or as policies trigger scans). You don't need to re-run anything manually — check the resource page for updated sovereign control status over time.

## Delete a Sovereign View

You can delete the Sovereign View resource from the Azure portal by selecting **Delete** on the resource's page, just like any other Azure resource. To delete it, you need **Contributor** or **Owner** rights on the subscription and **Resource Policy Contributor** permission on the in-scope subscriptions and management groups.

Deleting the resource removes its managed identity and any stored data. It doesn't affect any of your other resources or configurations — it simply deletes the Sovereign View. If you need the view again later, recreate the resource and reassign permissions.

## Next steps

- [Troubleshooting and support](/docs/how-to/06-troubleshooting-and-support.md)
