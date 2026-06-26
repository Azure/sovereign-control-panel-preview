# Create a Sovereign View

After the resource provider is registered, you can create a Sovereign View resource. You can create it only on the subscriptions (in an allowlisted tenant) that you provided in the onboarding form.

## Prerequisites

- Complete [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md).
- Have **Contributor + Resource Policy Contributor** or **Owner** on the target subscription.

## Start the create experience

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | In the Azure portal's top search bar, **type Sovereign**, then select **Sovereign Control Panel**. | <img src="../assets/img-06.png" width="900" alt="Searching for Sovereign Control Panel in the Azure portal." /> |
| 2 | On the overview page, **select Create View**. | <img src="../assets/img-07.png" width="900" alt="Selecting Create View on the overview page." /> |

## Complete the Basics tab

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | The **Create view** page opens with the **Subscription** and **Resource group** prefilled. | <img src="../assets/img-08.png" width="900" alt="Create view page with prefilled Subscription and Resource group." /> |
| 2 | On the **Basics** tab, fill in the details:<br>• **Subscription** — the subscription you registered earlier.<br>• **Resource group** — an existing one, or create a new one.<br>• **Name** — a name for the resource (spaces aren't allowed).<br>• **Region** — where the resource metadata and processing reside. | <img src="../assets/img-09.png" width="900" alt="Filling in the Basics tab details." /> |
| 3 | Select **Next** to move to the **Scope** tab. | <img src="../assets/img-10.png" width="900" alt="Selecting Next to move to the Scope tab." /> |

## Select the scope

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Scope** tab, select **+ Add resources**. | <img src="../assets/img-11.png" width="900" alt="Selecting Add resources on the Scope tab." /> |
| 2 | Choose either a **Management group** (to include all subscriptions under it) or one or more specific **Subscriptions** to include in this Sovereign View. | <img src="../assets/img-12.jpg" width="900" alt="Selecting a management group or subscriptions for the scope." /> |
| 3 | After selecting the resources, select **Add**. | <img src="../assets/img-13.png" width="900" alt="Selecting Add to confirm the scope resources." /> |
| 4 | Select the items to include (or the checkbox next to **Name** for all), then select **Next**. | <img src="../assets/img-14.png" width="900" alt="Selecting subscriptions or management groups on the Scope page." /> |

## Configure the policy initiative

The Sovereign View focuses on specific control sets (for example, Data Residency or Encryption at Rest) relevant to data sovereignty. In the preview, these are largely predefined and selected for you.

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Policy initiative** tab, review the settings:<br>• **Data Residency (Geography)** — the default value of **Europe** is selected.<br>• Review the policies or controls that will be evaluated (for example, *Data sovereignty control levels* or *Encryption at rest*). | <img src="../assets/img-15.png" width="900" alt="Configuring the policy initiative tab." /> |
| 2 | Select **I confirm**, then select **Next**. Validation takes a few seconds. | <img src="../assets/img-16.png" width="900" alt="Selecting the I confirm checkbox before review." /> |

> [!TIP]
> To learn more about any Azure policy, see its definition on the [Azure Policy](https://portal.azure.com) page in the portal, or the [list of built-in policy definitions](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies).

## Review and create

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Review + create** tab, verify all configuration details (scope, name, region, and so on). | <img src="../assets/img-17.png" width="900" alt="Reviewing configuration details on the Review + create tab." /> |
| 2 | Select the confirmation checkbox, then select **Create** to deploy the Sovereign View resource. | <img src="../assets/img-18.png" width="900" alt="Deployment completed for the Sovereign View resource." /> |

The deployment completes within a few seconds, and your Sovereign View resource is created.

## Next steps

- [Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md)
