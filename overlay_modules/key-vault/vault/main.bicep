@description('Required. Name of the Key Vault. Must be globally unique.')
@maxLength(24)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. All secrets to create.')
@secure()
param secrets object = {}

@description('Optional. All keys to create.')
param keys array = []

@description('Optional. Specifies if the vault is enabled for deployment by script or compute. Default is set to false.')
param enableVaultForDeployment bool = false

@description('Optional. Specifies if the vault is enabled for a template deployment. Default is set to false.')
param enableVaultForTemplateDeployment bool = false

@description('Optional. Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. Default is set to false.')
param enableVaultForDiskEncryption bool = false

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'AzureServices'
  'None'
])
@description('Optional. Indicates what traffic can bypass network rules. This can be \'AzureServices\' or \'None\'. It must be set to \'AzureServices\' if \'enableVaultForDeployment\' or \'enableVaultForTemplateDeployment\' are set to true. Default value is set to \'None\'..')
param networkRuleSetBypass string = 'None'

@description('Required. Existing Private Endpoint Virtual Network Resoruce Group name.')
param privateEndpointVirtualNetworkResourceGroup string

@description('Required. Existing Private Endpoint Virtual Network name.')
param privateEndpointVirtualNetworkName string

@description('Required. Existing Private Endpoint Subnet name.')
param privateEndpointSubnetName string

@description('Required. The name of the private endpoint.')
param privateEndpointName string

@description('Optional. The custom name of the network interface attached to the private endpoint.')
param privateEndpointNicName string = ''

@description('Optional. The static privavte IP address for the private endpoint.')
param privateEndpointIP string = ''

@description('Conditional. The resource IDs of the Application Security Groups (ASGs) for the private endpoint. Required if ASGs are required to be attached to the private endpoint.')
param privateEndpointAsgResourceIds array = []

var moduleVersion = loadJsonContent('./version.json').version

var mergedTags = union(tags, {
    'hidden-module_name': 'key-vault/vault'
    'hidden-module_version': moduleVersion
  })
var peAsgs = [for asg in privateEndpointAsgResourceIds: {
  id: asg
}]
// ---------- Lookup Private Endpoint subnet ----------

resource peVnet 'microsoft.network/virtualNetworks@2022-07-01' existing = {
  name: privateEndpointVirtualNetworkName
  scope: resourceGroup(privateEndpointVirtualNetworkResourceGroup)

  resource peSubnet 'subnets' existing = {
    name: privateEndpointSubnetName
  }
}
module standardKeyVault '../../../carml_modules/key-vault/vault/main.bicep' = {
  name: take('ContosoKeyVault-${name}', 64)
  params: {
    name: name
    tags: mergedTags
    location: location
    vaultSku: 'premium'
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableVaultForDeployment: enableVaultForDeployment
    enableVaultForDiskEncryption: enableVaultForDiskEncryption
    enableVaultForTemplateDeployment: enableVaultForTemplateDeployment
    softDeleteRetentionInDays: 90
    networkAcls: {
      bypass: networkRuleSetBypass
      defaultAction: 'Deny'
    }
    secrets: secrets
    keys: keys
    enableDefaultTelemetry: false
    privateEndpoints: [
      {
        name: privateEndpointName
        service: 'vault'
        subnetResourceId: peVnet::peSubnet.id
        applicationSecurityGroups: !empty(privateEndpointAsgResourceIds) ? peAsgs : null
        customNetworkInterfaceName: privateEndpointNicName
        tags: tags
        ipConfiguration: !empty(privateEndpointIP) ? {
          name: 'ipconfig1'
          properties: {
            groupId: 'vault'
            memberName: 'vault'
            privateIPAddress: !empty(privateEndpointIP) ? privateEndpointIP : null
          }
        } : any(null)
      }
    ]
  }
}

// =========== //
// Outputs     //
// =========== //
@description('The resource ID of the key vault.')
output resourceId string = standardKeyVault.outputs.resourceId

@description('The name of the resource group the key vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the key vault.')
output name string = standardKeyVault.name

@description('The URI of the key vault.')
output uri string = standardKeyVault.outputs.uri

@description('The location the resource was deployed into.')
output location string = standardKeyVault.outputs.location
