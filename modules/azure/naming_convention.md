# naming convention

## general naming scheme

- resource type (rt)
- business unit (businessunit)
- solution
- client
- environment (env)
- geography (geo)
- name
- instance

ex: db-aa-forecasting-main-dev-northeu-001

## notes
`environment` could also be removed from the resource group naming as has environments might be separated by 
subscriptions (`Org DEV`, `Org Prod`) but we may keep it in the scheme for readability purposes, 
and also as we might want to have further environments as for instance `UAT`, `SIT`, 
which in case will be under the development resource group

## resource naming examples
- resource group: `geo` and `instance` don't apply 0 `rt0businessunit0solution0client0env` (ex: rg0aa0forecasting0team0dev)
- storage account: it is scoped inside a resource group so it can be simplified to `rt0name0env0geo0instance`  (ex: st0files0dev0westus0001)
- data lake storage account: `rt0name0env0geo0instance` (ex: dls0uploadlake0prod0northeurope0001)
- event hub: `rt0name0env0geo0instance` (ex: evh0stockprices0dev0northeurope0001)
- storage container: `env` and `geo` are scoped in the storage account so `rt0name0instance` (ex: stc0stockprices0001)
- storage table: `rt0name0env0geo0instance` (ex: stt0stockprices0dev0northeurope0001)
- app registration: `rt0businessunit0solution0client0env0name` (ex: app0eng0prices0team0dev0tf)
