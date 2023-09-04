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

// ---------- Storage Account Parameters ----------
@description('Name of the Storage Account')
param storageAccountName string

@description('Conditional. Name of the blob Private Endpoint. Required if private endpoint for blob is required.')
param blobPrivateEndpointName string = ''

@description('Conditional. Name of the dfs Private Endpoint. Required if private endpoint for blob is required.')
param dfsPrivateEndpointName string = ''

// ---------- Key Vault Parameters ----------
@description('Name of the Key Vault')
param keyVaultName string

@description('Conditional. Name of the blob Private Endpoint. Required if private endpoint for blob is required.')
param keyVaultPrivateEndpointName string = ''

// ---------- Variables ----------
var deploymentNameSuffix = last(split(deployment().name, '-'))

var blobPeNicName = 'nic-${blobPrivateEndpointName}'
var dfsPeNicName = 'nic-${dfsPrivateEndpointName}'

// ---------- Resource Groups ----------

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// ---------- Key Vault ----------
module demoKeyVault 'br/taoyang-br-modules:key-vault:1.0.0' = {
  name: take('Demo-kv-${deploymentNameSuffix}', 64)
  scope: rg
  params: {
    tags: tags
    location: location
    name: keyVaultName
    enableVaultForDeployment: true
    enableVaultForTemplateDeployment: true
    privateEndpointVirtualNetworkResourceGroup: privateEndpointVirtualNetworkResourceGroup
    privateEndpointVirtualNetworkName: privateEndpointVirtualNetworkName
    privateEndpointSubnetName: privateEndpointSubnetName
    privateEndpointName: keyVaultPrivateEndpointName

  }
}
// ---------- Storage Account ----------
module demoStorage 'ts/taoyang-ts-modules:storage-account:1.0.0' = {
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
    blobPrivateEndpointName: blobPrivateEndpointName
    blobPrivateEndpointNicName: blobPeNicName
    dfsPrivateEndpointName: dfsPrivateEndpointName
    dfsPrivateEndpointNicName: dfsPeNicName
    privateEndpointVirtualNetworkResourceGroup: privateEndpointVirtualNetworkResourceGroup
    privateEndpointVirtualNetworkName: privateEndpointVirtualNetworkName
    privateEndpointSubnetName: privateEndpointSubnetName
    systemAssignedIdentity: true
  }
}

// ---------- storage account Outputs ----------
output storageAccountName string = demoStorage.outputs.name
output storageAccountResourceId string = demoStorage.outputs.resourceId
output storageAccountIdentityPrincipalId string = demoStorage.outputs.systemAssignedPrincipalId

// ---------- key vault Outputs ----------
output keyVaultName string = demoKeyVault.outputs.name
output keyVaultResourceId string = demoKeyVault.outputs.resourceId
