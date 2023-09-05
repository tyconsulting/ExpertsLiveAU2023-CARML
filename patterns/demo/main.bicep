targetScope = 'subscription'
// ---------- Common Parameters ----------
@description('Location for all Resources.')
param location string = 'australiaeast'

@description('Tag values')
param tags object = {}

@description('Name of the Resource Group')
param resourceGroupName string

@description('Required. Existing Private Endpoint Virtual Network Resoruce Group name.')
param privateEndpointVirtualNetworkResourceGroup string

@description('Required. Existing Private Endpoint Virtual Network name.')
param privateEndpointVirtualNetworkName string

@description('Required. Existing Private Endpoint Subnet name.')
param privateEndpointSubnetName string

@description('Optional. Get current time stamp. This is used to generate unique name for key vault. DO NOT provide a value.')
param now string = utcNow()

// ---------- Storage Account Parameters ----------
@description('Name of the Storage Account')
param storageAccountName string

// ---------- Key Vault Parameters ----------
@description('Prefix of the Key Vault name')
param keyVaultNamePrefix string

// ---------- Variables ----------
var deploymentNameSuffix = last(split(deployment().name, '-'))

var keyVaultNameSuffix = substring((uniqueString(now, location)), 0, 5)
//This is required because soft delete and purge protection is enabled. You cannot re-use the same KV name after deletion until the purge protection period has passed.
var keyVaultName1 = '${keyVaultNamePrefix}${keyVaultNameSuffix}01'
var keyVaultName2 = '${keyVaultNamePrefix}${keyVaultNameSuffix}02'
// ---------- Resource Groups ----------

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ---------- Deploy Key Vault from local module ----------
module keyVaultFromLocalModule '../../overlay_modules/key-vault/vault/main.bicep' = {
  name: take('Demo-kv1-${deploymentNameSuffix}', 64)
  scope: rg
  params: {
    tags: tags
    location: location
    name: keyVaultName1
    networkRuleSetBypass: 'AzureServices'
    enableVaultForDeployment: true
    enableVaultForTemplateDeployment: true
    privateEndpointVirtualNetworkResourceGroup: privateEndpointVirtualNetworkResourceGroup
    privateEndpointVirtualNetworkName: privateEndpointVirtualNetworkName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateEndpointName: 'pe-${keyVaultName1}'

  }
}

// ---------- Deploy Key Vault from Bicep Registry ----------
module keyVaultFromBR 'br/taoyang-br-modules:key-vault:1.0.0' = {
  name: take('Demo-kv2-${deploymentNameSuffix}', 64)
  scope: rg
  params: {
    tags: tags
    location: location
    name: keyVaultName2
    networkRuleSetBypass: 'None'
    enableVaultForDeployment: false
    enableVaultForTemplateDeployment: false
    privateEndpointVirtualNetworkResourceGroup: privateEndpointVirtualNetworkResourceGroup
    privateEndpointVirtualNetworkName: privateEndpointVirtualNetworkName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateEndpointName: 'pe-${keyVaultName2}'

  }
}
// ---------- Deploy Storage Account using Template Specs----------
module storageAccountFromTS 'ts/taoyang-ts-modules:storage-account:1.0.0' = {
  name: take('Demo-storage-${deploymentNameSuffix}', 64)
  scope: rg
  params: {
    tags: tags
    location: location
    name: storageAccountName
    accessTier: 'Hot'
    kind: 'StorageV2'
    skuName: 'Standard_LRS'
    enableHierarchicalNamespace: true
    supportsHttpsTrafficOnly: true
    blobPrivateEndpointName: 'pe-${storageAccountName}-blob'
    blobPrivateEndpointNicName: 'nic-pe-${storageAccountName}-blob'
    dfsPrivateEndpointName: 'pe-${storageAccountName}-dfs'
    dfsPrivateEndpointNicName: 'nic-pe-${storageAccountName}-dfs'
    privateEndpointVirtualNetworkResourceGroup: privateEndpointVirtualNetworkResourceGroup
    privateEndpointVirtualNetworkName: privateEndpointVirtualNetworkName
    privateEndpointSubnetName: privateEndpointSubnetName
    systemAssignedIdentity: true
  }
}

// ---------- storage account Outputs ----------
output storageAccountName string = storageAccountFromTS.outputs.name
output storageAccountResourceId string = storageAccountFromTS.outputs.resourceId
output storageAccountIdentityPrincipalId string = storageAccountFromTS.outputs.systemAssignedPrincipalId

// ---------- key vault Outputs ----------
output keyVaultName1 string = keyVaultFromLocalModule.outputs.name
output keyVaultResourceId1 string = keyVaultFromLocalModule.outputs.resourceId

output keyVaultName2 string = keyVaultFromBR.outputs.name
output keyVaultResourceId2 string = keyVaultFromBR.outputs.resourceId
