# Prerequisites and roles

Use this guide to confirm you have the access and permissions needed before you onboard to the Sovereign Control Panel (SCP) Private Preview.

## Required

Before you begin onboarding, make sure the following are in place:

- Your Azure tenant ID and the subscription IDs you want to evaluate have been shared with Microsoft through the onboarding form.
- You have sufficient Azure RBAC access to create a Sovereign View and configure its scope, as described in the table below.

## Roles and access

The following Azure roles are required for each onboarding action.

### ROLE & ACCESS

| **Action** | **Role(s) required** |
|---|---|
| **Create a Sovereign view** | • Contributor access to the subscription where user wants to create view. **AND**<br>• Contributor + Resource Policy Contributor on all scoped resources\*<br><br>**OR**<br><br>• Owner permission on subscription where view is to be created and on all the scoped resources. |
| **Assign roles to the Sovereign view identity (grant Reader + Resource Policy Contributor)** | • User Access Administrator on all scoped resources<br><br>**OR**<br><br>• Owner on all the scoped resources. |
| **View report of a Sovereign view** *(User can view report only if assign role to view identity is completed)* | • Reader permission on the Sovereign view |
| **Delete a Sovereign view** | • Contributor on the subscription where view is created **AND**<br>• Resource Policy Contributor on all the scoped resources<br><br>**OR**<br><br>• Owner permission on subscription where view is to be created and on all the scoped resources. |

> [!NOTE]
> Scoped resources - These are the subscriptions and management groups for which you would like to evaluate sovereignty posture. All resources within the selected subscriptions and management groups will be included in the sovereignty posture assessment. 

## Next steps

- [Register the resource provider](/docs/how-to/02-register-resource-provider.md)
