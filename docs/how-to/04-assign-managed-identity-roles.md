# Assign managed identity roles

After you create a Sovereign View, you must grant its managed identity read access to your environment so it can collect data and generate the sovereignty control report.

The Sovereign View resource has a **system-assigned managed identity**. For each subscription and management group in the view's scope, assign this identity the **Reader** and **Resource Policy Contributor** roles. You can do this manually in the Azure portal or by running a PowerShell script.

## Prerequisites

- Complete [Module 3: Create a Sovereign View](/docs/how-to/03-create-sovereign-view.md).
- Have **Owner** or **User Access Administrator** permission to assign Azure roles.

## Confirm the identity assignment permission

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | After a successful deployment, select **Go to resource** to open the Sovereign View resource. | <img src="../assets/img-19.png" width="700" alt="Selecting Go to resource after deployment." /> |
| 2 | In the left menu, under **Settings**, select **Properties** and check whether **Identity assignment permission** is **Yes**. If it's **No**, obtain the Reader permission needed to assign the managed identity before continuing. | <img src="../assets/img-20.png" width="700" alt="Checking Identity assignment permission on the Properties page." /> |

The Sovereign View resource has a system-assigned managed identity. You can assign its roles manually in the Azure portal or by running a PowerShell script.

<img src="../assets/img-21.jpg" width="700" alt="Overview of assigning the managed identity roles." />

## Option 1: Assign roles manually

<img src="../assets/img-22.png" width="700" alt="Starting the manual role-assignment steps." />

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | In the Sovereign View, select **Properties**, then select a management group or subscription in scope, **one at a time**. | <img src="../assets/img-23.png" width="700" alt="Selecting a management group or subscription to assign the Reader role." /> |
| 2 | On the subscription (or management group) page, select **Access control (IAM)**, then select **+ Add** > **Add role assignment**. | <img src="../assets/img-24.png" width="700" alt="Selecting Add role assignment under Access control (IAM)." /> |
| 3 | **Search for Reader**, and select it. | <img src="../assets/img-25.png" width="700" alt="Searching for and selecting the Reader role." /> |
| 4 | In **Assign access to**, choose **User, group, or service principal**, then search for and select the Sovereign View's managed identity (it appears as a service principal). | <img src="../assets/img-26.png" width="700" alt="Selecting the Sovereign View managed identity as the assignee." /> |
| 5 | Select **Review + assign** to finalize the role assignment. | <img src="../assets/img-27.jpg" width="700" alt="Selecting Review + assign to finalize the Reader assignment." /> |
| 6 | Repeat the steps above to also assign the **Resource Policy Contributor** role to the same managed identity. | <img src="../assets/img-28.jpg" width="700" alt="Searching for and selecting the Resource Policy Contributor role." /><br><img src="../assets/img-29.jpg" width="700" alt="Adding the managed identity as the assignee for Resource Policy Contributor." /> |

Repeat this process for **each** subscription and management group in your Sovereign View scope. This grants the Sovereign View permission to read the configuration of resources in those scopes.

## Option 2: Assign roles by using the PowerShell script

The [`assign-roles.ps1`](/docs/scripts/assign-roles.ps1) script grants the view's managed identity the **Reader** and **Resource Policy Contributor** roles across the in-scope subscriptions so it can read resources and evaluate policy.

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | **Open the Sovereign View**. | <img src="../assets/img-30.png" width="700" alt="Opening the Sovereign View before granting roles." /> |
| 2 | Select **PowerShell** at the top of the portal to open **Azure Cloud Shell**. | <img src="../assets/img-31.png" width="700" alt="Opening Azure Cloud Shell in PowerShell mode." /> |
| 3 | In Cloud Shell, select **Manage files** > **Upload**, and upload the [`assign-roles.ps1`](/docs/scripts/assign-roles.ps1) script. | <img src="../assets/img-32.png" width="700" alt="Selecting Manage files to upload the script." /><br><img src="../assets/img-34.png" width="700" alt="Uploading the assign-roles.ps1 script to Cloud Shell." /> |
| 4 | Run the script with `./assign-roles.ps1`. It verifies your sign-in, installs the resource-graph extension (one time), and lists the available Sovereign Views. | <img src="../assets/img-35.png" width="700" alt="Running the assign-roles.ps1 script in Cloud Shell." /> |
| 5 | **Enter the number** of your Sovereign View. The script retrieves the view's managed identity principal ID and displays its scope — the subscriptions and management groups assigned to the view. | <img src="../assets/img-36.png" width="700" alt="Selecting the target Sovereign View in the script." /> |
| 6 | Review the planned assignments (it shows which of **Reader** and **Resource Policy Contributor** are missing for each scope item), then enter **Y** to proceed. | <img src="../assets/img-37.png" width="700" alt="Confirming the planned role assignments." /> |
| 7 | The script assigns the roles to the managed identity on each in-scope subscription and prints a summary. | <img src="../assets/img-38.png" width="700" alt="Summary of assigned roles printed by the script." /> |

> [!TIP]
> Run `./assign-roles.ps1 -DryRun` first to preview the assignments without making any changes.

## Verify the assignments

| # | Step | Screenshot |
| :-: | --- | --- |
| 1 | On the Sovereign View, open **Access control (IAM)** > **Role assignments** and filter by the view name. Confirm the managed identity holds both the **Reader** and **Resource Policy Contributor** roles. | <img src="../assets/img-39.png" width="700" alt="Verifying the role assignments under Access control (IAM)." /> |
| 2 | Open **Settings** > **Properties**. On the **Scope** tab, each subscription shows its **Identity assignment permission** status, confirming the managed identity has the access it needs to evaluate the view. | — |

## Report generation

After the role assignments are in place, the Sovereign View begins collecting data. An initial scan completes within 24 hours.

If the report doesn't generate or remains empty, confirm that the managed identity has Reader rights on all relevant scopes. If you selected a management group that contains multiple subscriptions, make sure access is assigned at the management group level so it inherits down to the contained subscriptions.

## Next steps

- [View the sovereignty control report](/docs/how-to/05-view-compliance-report.md)
