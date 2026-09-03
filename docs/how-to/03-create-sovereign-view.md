# Create a Sovereign View

After the resource provider is registered, you can create a Sovereign View resource. You can create it only on the subscriptions (in an allowlisted tenant) that you provided in the onboarding form.

## Prerequisites

- Complete [Module 2: Register the resource provider](/docs/how-to/02-register-resource-provider.md).
- Have **Contributor + Resource Policy Contributor** or **Owner** on the target subscription.

## Start the create experience

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | In the Azure portal's top search bar, type **Sovereign**, then select **Sovereign Control Panel**. | <img src="../assets/img-06.png" width="900" alt="Searching for Sovereign Control Panel in the Azure portal." /> |
| 2 | On the overview page, **select Create View**. | <img src="https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/assets/docs/assets/img-07.png" width="900"> |

## Complete the Basics tab

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | The **Create view** page opens with the **Subscription** and **Resource group** prefilled. | <img src="../assets/img-08.png" width="900" alt="Create view page with prefilled Subscription and Resource group." /> |
| 2 | On the **Basics** tab, fill in the details:<br>• **Subscription** — Choose the subscription where you want to create this Sovereign view resource (the same subscription you registered above). .<br>• **Resource group** — Select an existing resource group or create a new one to host the Sovereign view resource. .<br>• **Name** — Enter a name for your Sovereign view resource [doesn’t allow space].<br>• **Region** — Choose an Azure region for the resource. (This is simply where the metadata and processing for the resource will reside). . | <img src="../assets/img-09.png" width="900" alt="Filling in the Basics tab details." /> |
| 3 | Select **Next** to move to the **Scope** tab. | <img src="../assets/img-10.png" width="900" alt="Selecting Next to move to the Scope tab." /> |

## Select the scope

As you add scopes, SCP checks whether you have permission to assign roles on each subscription and management group, and shows the result in the **Role assignment** column:

- **Yes** — SCP automatically assigns the **Reader** and **Resource Policy Contributor** roles to the Sovereign View's managed identity when the view is created. **Owner** or **User Access Administrator** on the scope provides this capability.
- **No** — You can still select the scope and create the view, but SCP can't assign the roles automatically. Ask an **Owner** or **User Access Administrator** for the scope to assign the roles, then verify the permission status after deployment.

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Scope** tab, select **+ Add resources**. SCP checks your role assignment permission for every subscription and management group shown in **Add resources**. | <img src="../assets/img-11.png" width="900" alt="Selecting Add resources on the Scope tab." /> |
| 2 | You can choose a **Management Group** (to include all subscriptions under it) or/and one or more specific **Subscriptions** to be included in this Sovereign view. Use the UI controls to select the desired management group and/or subscription(s) from the list. | <img src="../assets/img-12.jpg" width="900" alt="Selecting a management group or subscriptions for the scope." /> |
| 3 | After selecting the resources, select **Add** at the bottom. SCP shows the permission result for each scope in the **Role assignment** column — **Yes** means the roles are assigned automatically at creation; **No** means an **Owner** or **User Access Administrator** must assign them after the view is created. | <img src="../assets/img-13.png" width="900" alt="Selecting Add to confirm the scope resources." /> |
| 4 | On the **Scope** page, remove any subscriptions or management groups you don't want to include for scope assessment by selecting them and choosing **Remove**. When your selection is complete, select **Next** to continue. | <img src="../assets/img-14.png" width="900" alt="Selecting subscriptions or management groups on the Scope page." /> |

## Configure the policy initiative

The Sovereign view focuses on specific dimensions or control sets (e.g., Data Residency, Encryption at Rest, etc.) relevant to data sovereignty. All your scoped resources will be evaluated against these policy initiatives. Data Residency is a mandatory policy initiative, the rest two are optional. 

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Policy initiative** tab, review the settings:<br>• **Data Residency (Geography)** — In the current preview, the default value of Europe will be available.<br> • **Encryption at rest** – Select this if you want to evaluate your resources for this policy initiative. <br> • **Controlled Network Exposure** – Select this if you want to evaluate your resources against the two policy initiatives defined in this dimension. | <img src="../assets/img-15.png" width="900" alt="Configuring the policy initiative tab." /> |
| 2 | Check the **“I confirm”** to allow SCP to proceed with creating the resource and associated policy assignments. <br>All policy assignments are created in non-enforcing. Azure Sovereign view does not block any operations or auto-remediate; it only reports sovereign control data. <br>Once done click next at the bottom to finally review and create the Sovereign view. . | <img src="../assets/img-16.png" width="900" alt="Selecting the I confirm checkbox before review." /> |

> [!TIP]
> To learn more about any Azure policy, see its definition on the [Azure Policy](https://ms.portal.azure.com/#view/Microsoft_Azure_Policy/PolicyMenuBlade.MenuView/~/Definitions) page in the portal, or the [list of built-in policy definitions](https://learn.microsoft.com/azure/governance/policy/samples/built-in-policies).

## Review and create

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the **Review + create** tab, verify all configuration details (scope, name, region, etc.). Then check the box and click Create to deploy the Sovereign view resource. | <img src="../assets/img-17.png" width="900" alt="Reviewing configuration details on the Review + create tab." /> |
| 2 | Post clicking the **Create** button, within few seconds the deployment will be completed, and your Sovereign view resource will be generated.. | <img src="../assets/img-18.png" width="900" alt="Deployment completed for the Sovereign View resource." /> |

The deployment completes within a few seconds, and your Sovereign View resource is created.

## Next steps

- [Assign managed identity roles](/docs/how-to/04-assign-managed-identity-roles.md)
