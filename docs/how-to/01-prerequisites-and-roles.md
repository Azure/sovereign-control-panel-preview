# Prerequisites and roles

Use this guide to confirm you have the access and permissions needed before you onboard to the Sovereign Control Panel (SCP) Private Preview.

## Required

Before you begin onboarding, make sure the following are in place:

- Your Azure tenant ID and the subscription IDs you want to evaluate have been shared with Microsoft through the onboarding form.
- You have sufficient Azure RBAC access to create a Sovereign View and configure its scope, as described in the table below.

## Roles and access

The following Azure roles are required for each onboarding action.

| Action | Role(s) required |
| ------ | ---------------- |
| Create a Sovereign View | Contributor **and** Resource Policy Contributor, **or** Owner |
| Assign roles to the Sovereign View identity (grant Reader + Resource Policy Contributor) | User Access Administrator, **or** Owner |
| View the compliance report of a Sovereign View | Read permission on the Sovereign View, **or** Contributor + Resource Policy Contributor |
| Delete a Sovereign View | Contributor **and** Resource Policy Contributor, **or** Owner |

> [!NOTE]
> A user with **Contributor + Resource Policy Contributor + User Access Administrator** can create a Sovereign View, assign its managed identity, and view the reports end to end.

## Next steps

- [Register the resource provider](/docs/how-to/02-register-resource-provider.md)
