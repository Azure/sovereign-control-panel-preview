# Sovereign Control Panel Private Preview

Sovereign Control Panel (SCP) is a new Azure sovereignty posture control center that gives organizations transparency, control, and confidence as they work to meet their sovereignty and compliance requirements. It offers a single unified view — a "single pane of glass" — showing where your organization stands on data sovereignty and regulatory compliance across your Azure estate.

This repository contains the onboarding documentation for the SCP Private Preview.

> [!IMPORTANT]
> Sovereign Control Panel is currently in an **invite-only Private Preview (Private Preview)**. 

## What SCP does in Private Preview

Private Preview focuses on the **View Experience** — the ability to create and view Sovereign Compliance "Views" across your Azure environment. In this phase, SCP is **read-only**: it does not create or modify cloud resources, making it a safe, observational tool for compliance monitoring. It emphasizes posture visibility, helping you monitor existing Azure resources ("brownfield" environments) for compliance signals without changing them.

With SCP, you can:

- View your sovereignty control postures across subscriptions and management groups in one place.
- Create **Sovereign Views** that scope an evaluation to the resources and control signals you care about.
- Drill down from a high-level posture summary to the specific resource that is flagged, and understand why.
- Generate audit-ready posture reports for internal stakeholders, auditors, and regulators.

## Key concept: Sovereign View

A **Sovereign View (Preview)** is a new Azure resource type used to define what you want to monitor for sovereignty compliance. Creating a Sovereign View lets you select:

- A **scope** of Azure resources — for example, a single subscription, a group of subscriptions, or a management group hierarchy.
- A set of **sovereign control signals** (policy-based initiatives) to assess.

The result is a tailored compliance view for that scope, surfaced in the Azure portal.


