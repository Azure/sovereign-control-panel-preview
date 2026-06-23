# Glossary

Definitions of key sovereignty and Azure terms used throughout the Sovereign Control Panel onboarding documentation.

| Term | Definition |
| ---- | ---------- |
| Tenant (Microsoft Entra ID) | A tenant in Azure (also called a Microsoft Entra ID directory) is a dedicated instance that represents an organization. Each tenant is a separate, isolated directory of identities and resources for one organization. |
| Azure subscription | A logical container for Azure resources and a unit of accounting and billing. Each subscription is associated with one tenant and can host any number of cloud resources (VMs, storage, and so on). |
| Management group | A container for organizing multiple subscriptions into a hierarchy. Management groups let you apply governance — such as policies or access controls — across all subscriptions in the group simultaneously. |
| Resource provider | An Azure service that supplies a set of resource types. It's identified by a namespace and defines the REST API for creating and managing those resources. To use certain resource types, the corresponding resource provider must be registered in your subscription. |
| Managed identity | An identity that lets Azure services authenticate to other services securely, without storing credentials in code. |
| Data sovereignty | An organization's control and jurisdiction over its data. It ensures data is subject to the laws and governance of the nation or region where it's collected and stored, often requiring data to reside within specified borders to comply with local privacy and security regulations. |
| Data residency | Keeping data physically stored within a defined geographic area or country. Many regulations enforce data residency so that certain data (for example, personal or sensitive data) doesn't leave the country or region. |
| Data encryption | The process of protecting data by transforming it into unreadable code using cryptographic keys. In Azure, data encryption is used both at rest (stored data) and in transit (data moving over networks). |
| Encryption at rest | Data stored on disk or other storage is encrypted to prevent unauthorized access. Azure automatically uses strong encryption for many services to protect data at rest. |
| Controlled network exposure | Assesses whether Azure resources are accessible only through approved network paths, helping reduce unintended exposure and support security, compliance, and data residency requirements. |
| Compliant | A resource or scope meets all the policy requirements that apply to it. The resource has no active policy violations. |
| Non-compliant | A resource or scope failed one or more policy checks. Azure Policy marks a resource as non-compliant when it violates at least one condition of an assigned policy or initiative. |
