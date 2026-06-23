# Troubleshooting and support

Use this guide to resolve common onboarding issues, understand the preview's limitations, and find out how to get help.

## Limitations and known issues (preview)

Sovereign View is in Private Preview. Be aware of these known constraints:

- **No editing or updates**: Modifying an existing Sovereign View's settings or scope after creation isn't supported in preview. The resource is effectively read-only after creation. To change the scope or included controls, delete and recreate it.
- **Review only, no enforcement**: All evaluations are non-enforcing. Sovereign View doesn't block any operations or auto-remediate; it only reports sovereign control data. The underlying Azure policies are assigned in **DoNotEnforce** mode and don't affect your running services.
- **Support scope**: Preview support is currently limited to targeted customers. Work with the Microsoft product team or your account team by email or through the Microsoft Teams channel.

## Troubleshooting

**Sovereign View not visible or not creating**

Make sure the resource provider is registered (see [Module 2](/docs/how-to/02-register-resource-provider.md)) and that your account has the necessary permissions. If you can't find Sovereign Control Panel in the portal, confirm that you're enrolled in the preview program.

**Scope doesn't list all expected subscriptions or management groups**

This usually indicates a permission issue. The portal lists only resources where you have **Contributor + Resource Policy Contributor** or **Owner** access. If a subscription or management group is missing, have an admin grant you access, ask them to create the view, or temporarily create the Sovereign View in a subscription you control.

**The report is empty or incomplete**

This can happen when the managed identity lacks access to part of your scope. Revisit the role assignments for the identity (see [Module 4](/docs/how-to/04-assign-managed-identity-roles.md)) and make sure the **Reader** role is assigned on all specified subscriptions and management groups. If something was missed, add the role and allow time for the data to refresh.

**Understanding "Not Applicable" or "Not in definitions" statuses**

These statuses indicate that a particular sovereign control found no applicable resources in the evaluated scope, or that the control is conditional and wasn't evaluated for your scenario. Many "Not Applicable" entries can be normal — for example, a control about Key Vault encryption shows **Not Applicable** if you have no key vaults. The report is expected to be generated and accessible within 24 hours of the evaluation. If you suspect an error, contact support.

## Get help or give feedback

To report an issue or request assistance, contact your Microsoft account representative or submit a support request through the [Azure portal](https://portal.azure.com). For product feedback, reach us at **{email id}** or through Teams. You can also file bugs and feedback through [GitHub Issues](../../issues).

> [!NOTE]
> Don't report security vulnerabilities through public GitHub issues. See [SECURITY.md](/SECURITY.md) for reporting guidance.
