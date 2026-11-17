# Sovereign View Bicep packages

Choose a Microsoft.Sovereign package explicitly by API version. Keep the
template, parameter file, and helpers from the same package.

| Namespace | API version | Package | Contract |
| --- | --- | --- | --- |
| `Microsoft.Sovereign` | `2026-10-31-preview` | [Versioned package](./2026-10-31-preview) | Sweden Central example on public ARM with SystemAssigned identity, existing assignment references, Business Continuity, and dimension settings. Validate service readiness before deployment; no explicit role-provisioning resources. |
| `Microsoft.Sovereign` | `2026-03-15-preview` | [Legacy template](./main.bicep) and [parameters](./example.bicepparam) in this directory | Uses assignment parameters and explicit role-assignment modules. |

> [!IMPORTANT]
> The `2026-10-31-preview` package targets the
> [published API contract](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sovereign/resource-manager/Microsoft.Sovereign/Sovereign/preview/2026-10-31-preview/sovereign.json).

The existing files in this directory remain the legacy package. Do not mix its
role modules or parameter file with the new package. Customer examples contain
required placeholders and must not be deployed unchanged.

The new package includes `create-policy-assignments.ps1`: select dimensions
and scopes, use the initiatives' own defaults with optional overrides, and
generate assignment IDs ready for the view. Dedicated assignments default to
DoNotEnforce; no role grants are created. The helper uses public ARM.
Sweden Central is the supported production deployment region.
Review the template, example parameters, and helper script parameters before running.

## Maintaining versions

Bicep requires a literal resource type and API version; it does not support an
API-version parameter or interpolation in a native resource declaration.
Selecting a versioned directory selects the API contract. See
[Bicep resource declarations](https://learn.microsoft.com/azure/azure-resource-manager/bicep/resource-declaration)
and [diagnostic BCP047](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-core-diagnostics).

When supporting another API version, add a directory named after that exact
version. Review its schema, add matching examples, compile the
package, and update this catalog. Leave older package paths intact. Do not add
a moving `latest` alias or silently redirect an existing package to a newer
contract.

Keep each versioned download self-contained. Registration and policy-creation
helpers are included; the new template does not depend on legacy modules.
Existing role modules and scripts are retained for legacy users only.

