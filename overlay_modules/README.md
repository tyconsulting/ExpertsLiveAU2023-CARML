# Overlay Modules

## Instructions

### Publish module to a Private Bicep Registry

```powershell
$BicepRegistryName = 'acrtaobicepregistry'
$moduleRegistryIdentifier = 'bicep/key-vault'
$ModuleVersion = '1.0.0'
$TemplateFilePath = join-path $pwd 'key-vault/vault/main.bicep'
$publishingTarget = 'br:{0}.azurecr.io/{1}:{2}' -f $BicepRegistryName, $moduleRegistryIdentifier, $ModuleVersion
bicep publish $TemplateFilePath --target $publishingTarget --force
```

### Publish module as Template Specs

```powershell
set-azcontext -subscription 'Contoso Subscription'
$TemplateFilePath = join-path $pwd 'storage/storage-account/main.bicep'
$TemplateSpecsRgName = 'rg-template-specs'
$templateSpecInputObject = @{
  ResourceGroupName = $TemplateSpecsRgName
  Name              = 'storage-account'
  Version           = '1.0.0'
  Description       = "This module deploys a standardised Azure Storage Account that aligns with Contoso's security requirements."
  Location          = 'australiaeast'
  TemplateFile      = $TemplateFilePath
}
New-AzTemplateSpec @templateSpecInputObject -Force

```