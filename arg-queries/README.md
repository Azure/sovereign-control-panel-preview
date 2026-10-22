# Azure Resource Graph (ARG) Queries

This directory contains the Kusto Query Language (KQL) queries used by Sovereign Control Panel (SCP) to evaluate resource compliance posture across a Sovereign View scope.

When a compliance evaluation result in the Azure portal references an ARG query, its **View query** link points to the corresponding versioned `.kql` file in this folder (`arg-queries/<query-id>.<version>.kql`). You can also copy and run these queries directly in [Azure Resource Graph Explorer](https://portal.azure.com/#view/HubsExtension/ArgQueryBlade) to inspect the underlying resource properties in your own tenant.
