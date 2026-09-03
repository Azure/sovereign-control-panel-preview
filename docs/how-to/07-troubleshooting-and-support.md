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

**Sovereign View fails creation with Quota Exceeded Error**

For Sovereign Views to fetch the required report data, Sovereign Control Panel needs to assign some policies in Audit mode to the Subscriptions/Management Groups which are added to the scope. Azure Policy has [a maximum limit of 200 Policy Assignments](https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/governance/includes/policy/azure-policy-limits.md) per Subscription/Management Group.

Find the scopes in the failing Sovereign View which are close to or above this limit. You can use [the REST API](https://learn.microsoft.com/en-us/rest/api/policy-authorization/policy-assignments/list?view=rest-policy-authorization-2026-06-01&tabs=HTTP) to list all assignments for a Subscription/Management Group. Then
- Either remove them from the scope
- Delete any existing policy assignments which are not needed to create some headroom

Once done, please try creating the Sovereign View again. Reach out to the SCP contact listed below if the issue persists.

**Scope doesn't list all expected subscriptions or management groups**

This usually indicates a permission issue. The portal lists only resources where you have **Contributor + Resource Policy Contributor** or **Owner** access. If a subscription or management group is missing, have an admin grant you access, ask them to create the view, or temporarily create the Sovereign View in a subscription you control.

**The report is empty or incomplete**

This can happen when the managed identity lacks access to part of your scope. Revisit the role assignments for the identity (see [Module 4](/docs/how-to/04-assign-managed-identity-roles.md)) and **Reader** and **Resource Policy Contributor** role is properly assigned on all specified subscriptions and management groups. If something was missed, add the role and allow time for data to refresh. .

**Understanding "Not Applicable" or "Not in definitions" statuses**

These statuses indicate that a particular sovereign control found no applicable resources in the evaluated scope, or that the control is conditional and wasn't evaluated for your scenario. Many "Not Applicable" entries can be normal — for example, a control about Key Vault encryption shows **Not Applicable** if you have no key vaults. The report is expected to be generated and accessible within 24 hours of the evaluation. If you suspect an error, contact support.

**Sovereign View statuses**
 - **Healthy**: The Sovereign View is operationally ready and no permission action is required. 

 - **Permission Missing**: Reader or Resource Policy Contributor is missing on one or more scopes. Request Owner or User Access Administrator access, or ask someone with that access to assign the required roles. Then verify that the permission status updates successfully. 

 - **Unknown**: Unknown state can occur when there are API failures or the service returns 5xx or service is down. In this case, it is recommended to refresh and verify.

## Get help or give feedback

To report an issue or request assistance, contact your Microsoft account representative or email us. For product feedback, reach us at **Azscp@microsoft.com** or through Teams chat. 

> [!NOTE]
> Don't report security vulnerabilities through public GitHub issues. See [SECURITY.md](/SECURITY.md) for reporting guidance.
