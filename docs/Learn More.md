With SCP, you can:

- View your sovereignty and compliance posture across subscriptions and management groups in one place.
- Create **Sovereign Views** that scope an evaluation to the resources and control signals you care about.
- Drill down from a high-level posture summary to the specific resource that is flagged, and understand why.


## Key concept: Sovereign view

A **Sovereign view (Preview)** is a new Azure resource type used to define what you want to monitor for sovereignty control. Creating a Sovereign view lets you select:

- A **scope** of Azure resources — for example, a single subscription, a group of subscriptions, or a management group hierarchy.
- A set of **sovereign control signals** (policy-based initiatives, data encryption) to assess.

The result is a tailored compliance view for that scope, surfaced in the Azure portal.

## Features

| Feature | Description |
| ------- | ----------- |
|Centralised Experience| Aggregate sovereignty controls and signals across your Azure estate into one unified posture view. |
| Sovereign Views | Define reusable, scoped evaluations by subscription, management group, and selected control signals. |
| Drill-down and explainability | Move from high-level posture to the specific non-compliant resource, with reasoning on why it's flagged. |

## Who should use SCP

SCP is intended for organizations that are on Azure  and need to demonstrate strong alignment with local laws, policy frameworks while continuing to benefit from public-cloud innovation, resiliency, and security. 

Typical users of SCP include organizations that want to host some, or most of their workloads and resources in accordance with regulatory requirements, e.g., [SEAL framework](https://commission.europa.eu/document/download/09579818-64a6-4dd5-9577-446ab6219113_en). 

 - These can be national and federal government and public sector agencies.  

 - Regulated industries such as financial, healthcare, defense, energy, and critical infrastructure services. 

 - National and sovereign cloud operators 

The current Private Preview is invite-only and targets brownfield customers with existing Azure estates.

## Scenarios and capabilities

In this Private Preview we support the following scenarios:

 - **Sovereignty posture monitoring**. A "show me where I stand" view across data residency, encryption, network isolation — built from aggregated signals, not policy coverage alone. 

 - **Evaluating multi-resource controls.** Get a verdict on controls like Customer-Managed Keys or private endpoints, where correctness depends on several resources together. 
