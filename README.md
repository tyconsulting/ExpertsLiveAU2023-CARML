# Experts Live Australia 2023 CARML Demo

## Instruction

```powershell
new-azdeployment -Location 'Australia East' -Name 'carml' -TemplateFile ./patterns/demo/main.bicep -TemplateParameterFile ./patterns/demo/main.parameters-2.json -Verbose

```
## Resource Graph Queries

### Get all Overlay module usage

```kusto
resources
| where tags['hidden-module_name']  matches regex '.'
| summarize count() by type
```

### Get all Key Vaults deployed using Overlay module and show version

```kusto
Resources
Resources
| where type =~ "microsoft.keyvault/vaults"
| where tags['hidden-module_name'] =~ 'key-vault/vault'
| project name, tags
| mvexpand tags
| extend tagKey = tostring(bag_keys(tags)[0])
| extend tagValue = tostring(tags[tagKey])
| distinct name, tagKey, tagValue
| where tagKey =~ "hidden-module_version"
| project KeyVaultName = name, OverlayModuleVersion = tagValue
```