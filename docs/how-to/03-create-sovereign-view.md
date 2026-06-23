# Create a Sovereign View

After the resource provider is registered, you can create a Sovereign View resource. You can create it only on the subscriptions (in an allowlisted tenant) that you provided in the onboarding form.

## Prerequisites

- Complete [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md).
- Have **Contributor + Resource Policy Contributor** or **Owner** on the target subscription.

## Start the create experience

1. In the Azure portal's top search bar, type **Sovereign**, and then select **Sovereign Control Panel**.

   ![Searching for Sovereign Control Panel in the Azure portal.](/docs/assets/img-06.png)

1. On the overview page, select **Create View**.

   ![Selecting Create View on the overview page.](/docs/assets/img-07.png)

## Complete the Basics tab

The Create view page opens with the Subscription and Resource group prefilled.

![Create view page with prefilled Subscription and Resource group.](/docs/assets/img-08.png)

On the **Basics** tab, fill in the following details:

- **Subscription**: Choose the subscription where you want to create the Sovereign View resource (the same subscription you registered earlier).
- **Resource group**: Select an existing resource group, or create a new one to host the Sovereign View resource.
- **Name**: Enter a name for the Sovereign View resource. Spaces aren't allowed.
- **Region**: Choose an Azure region for the resource. This is where the resource metadata and processing reside.

![Filling in the Basics tab details.](/docs/assets/img-09.png)

Select **Next** to move to the **Scope** tab.

![Selecting Next to move to the Scope tab.](/docs/assets/img-10.png)

## Select the scope

1. On the **Scope** tab, select **+ Add resources**.

   ![Selecting Add resources on the Scope tab.](/docs/assets/img-11.png)

1. Choose either a **Management group** (to include all subscriptions under it) or one or more specific **Subscriptions** to include in this Sovereign View. Use the UI controls to select the desired management group and/or subscriptions from the list.

   ![Selecting a management group or subscriptions for the scope.](/docs/assets/img-12.jpg)

1. After selecting the resources, select **Add**.

   ![Selecting Add to confirm the scope resources.](/docs/assets/img-13.png)

1. On the **Scope** page, select the subscriptions or management groups you want to include. To include all available items, select the checkbox next to **Name**. When your selection is complete, select **Next**.

   ![Selecting subscriptions or management groups on the Scope page.](/docs/assets/img-14.png)

## Configure the policy initiative

The Sovereign View focuses on specific control sets (for example, Data Residency or Encryption at Rest) relevant to data sovereignty. In the preview, these are largely predefined and selected for you.

On the **Policy initiative** tab:

- **Data Residency (Geography)**: In the current preview, the default value of **Europe** is selected.
- Review the list of policies or controls that will be evaluated (for example, *Data sovereignty control levels* or *Encryption at rest*). These represent the scope definitions the Sovereign View uses.

![Configuring the policy initiative tab.](/docs/assets/img-15.png)

> [!TIP]
> To learn more about any Azure policy, see its definition on the [Azure Policy](https://portal.azure.com) page in the portal, or the [list of built-in policy definitions](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies).

Select **I confirm** to allow Azure to proceed with creating the resource and its associated identities, and then select **Next**. Validation takes a few seconds.

![Selecting the I confirm checkbox before review.](/docs/assets/img-16.png)

## Review and create

1. On the **Review + create** tab, verify all configuration details (scope, name, region, and so on).

   ![Reviewing configuration details on the Review + create tab.](/docs/assets/img-17.png)

1. Select the confirmation checkbox, and then select **Create** to deploy the Sovereign View resource.

   ![Deployment completed for the Sovereign View resource.](/docs/assets/img-18.png)

The deployment completes within a few seconds, and your Sovereign View resource is created.

## Next steps

- [Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md)
