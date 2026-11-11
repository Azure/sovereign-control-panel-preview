# Sovereign View Bicep packages

Choose a package explicitly by provider namespace and API version. Keep the
template, parameter file, and registration helper from the same package.

| Namespace | API version | Package | Guide | Contract |
| --- | --- | --- | --- | --- |
| `Private.RegEnvDev2608` | `2026-10-31-preview` | [Denmark East test package](./Private.RegEnvDev2608/2026-10-31-preview) | [Private test guide](./Private.RegEnvDev2608/2026-10-31-preview/README.md) | Private namespace, `denmarkeast` only, no managed identity. Use ARM Canary and a Canary-region resource group. Disposable assignments only: service cleanup can delete supplied references. |
| `Microsoft.Sovereign` | `2026-10-31-preview` | [Versioned package](./2026-10-31-preview) | [Deployment guide](/docs/how-to/03c-deploy-sovereign-view-with-bicep-2026-10-31-preview.md) | UK South example on public ARM with SystemAssigned identity, existing assignment references, Business Continuity, and dimension settings. Validate service readiness before deployment; no explicit role-provisioning resources. |
| `Microsoft.Sovereign` | `2026-03-15-preview` | [Legacy template](./main.bicep) and [parameters](./example.bicepparam) in this directory | [Legacy deployment guide](/docs/how-to/03b-deploy-sovereign-view-with-bicep.md) | Uses assignment parameters and explicit role-assignment modules. |

> [!IMPORTANT]
> The `2026-10-31-preview` package targets the
> [published API contract](https://github.com/Azure/azure-rest-api-specs/blob/main/specification/sovereign/resource-manager/Microsoft.Sovereign/Sovereign/preview/2026-10-31-preview/sovereign.json).
> Use it only after your service deployment supports that contract, including
> references to existing policy assignments. Publication of a specification and
> successful Bicep compilation do not establish live service compatibility.

The existing files in this directory remain the legacy package. Do not mix its
role modules or parameter file with the new package. Customer examples contain
required placeholders and must not be deployed unchanged.

## Maintaining versions

Bicep requires a literal resource type and API version; it does not support an
API-version parameter or interpolation in a native resource declaration.
Selecting a versioned directory selects the API contract and namespace. See
[Bicep resource declarations](https://learn.microsoft.com/azure/azure-resource-manager/bicep/resource-declaration)
and [diagnostic BCP047](https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-core-diagnostics).

When supporting another API version, add a directory named after that exact
version. Review its schema, add matching examples and a guide, compile the
package, and update this catalog. Leave older package paths intact. Do not add
a moving `latest` alias or silently redirect an existing package to a newer
contract.

For a different provider namespace, add a separate namespace directory with
its own API-version subdirectories. Keep registration helpers and resource
commands consistent with that namespace; do not alter an existing package to
point to a private test provider.

Keep each versioned download self-contained. The registration helper is copied
into the new package; the new template does not depend on legacy modules.
Existing role modules and scripts are retained for legacy users only.

Repository tags or pinned commit downloads can provide additional release
snapshots. If module release versions are introduced later, version the package
interface separately from the Azure API date version. A registry or template
spec is not required to use these local files.
