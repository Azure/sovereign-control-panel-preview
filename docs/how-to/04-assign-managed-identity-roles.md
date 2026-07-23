# Assign managed identity roles

After you create a Sovereign View, you must grant its managed identity read access so it can collect data and generate the sovereignty control report. 

The Sovereign View's **Properties** page can assign the managed identity roles for you. On the Properties tab, the view checks whether its managed identity already has the access to each in-scope subscription and management group, and lets you grant any missing **Reader** role in a single action. 

> [!NOTE]
>To use **Assign permissions for all**, you need **Owner** or **User Access Administrator** on each scope, because assigning roles requires that permission. 

## Prerequisites

- Complete [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md).
- Have **Owner** or **User Access Administrator** permission to assign Azure roles.

## Confirm the identity assignment permission

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the Sovereign View page select Settings > Properties. Review the Permission status column. Items where the managed identity is missing access show ⚠ Assign Permission. | <img src="https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/19.png" width="900" alt="Assign Permission." /> |
| 2 | Select **Assign permissions** for all to grant the required roles to every in-scope item at once.  | <img src="../assets/img-20.png" width="900" alt="Checking Identity assignment permission on the Properties page." /> |
| 3 |Each item moves from **Assigning** to **Assigned**, and a **Permissions assigned** notification confirms the roles were granted to the managed identity. | <img src="../assets/img-22.png" width="1200" alt="looking through subscriptions." /> |

## If the assignment isn't available 

If Assign permissions for all is disabled, get the necessary permissions.

| Symptom  | Cause and fix | Screenshot |
| :-: | --- | --- |
|  A scope shows **No access** and the button is disabled. |You don't have rights to assign roles on that scope. Request **Owner** or** User Access Administrator** access for the scope (or ask someone who has it to run the assignment). | <img src="https://github.com/Azure/sovereign-control-panel-private-preview/blob/main/docs/assets/img-21.jpg" width="900" alt="No access." /> |
| A **Managed identity** **details are missing** banner appears and the button is disabled. | The view's system-assigned managed identity isn't enabled. Open **Settings** > **Identity**, set the **System assigned** status to **On** . | <img src="../assets/img-24.png" width="1200" alt="Selecting Add role assignment under Access control (IAM)." />|

## Verify Access 

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the Sovereign View, open **Access control (IAM)** > **Role assignments** and filter by the view name. Confirm the managed identity holds both the **Reader** role. . | <img src="../assets/img-30.png" width="1200" alt="Opening the Sovereign View before granting roles." /> |


## Report generation

Once the above role assignments are in place, the Sovereign view will begin collecting data. An initial scan will be completed within 24 hours.

## Next steps

- [View the sovereignty control report](/docs/how-to/05-view-compliance-report.md)
