targetScope = 'subscription'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'ms.storage.storageaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param location string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'ssablob'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '<<namePrefix>>'

// ============ //
// Dependencies //
// ============ //
var virtualNetworkName = 'dep-${namePrefix}-vnet-${serviceShort}'
module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    asgName: 'dep-${namePrefix}-asg-${serviceShort}'
    virtualNetworkName: virtualNetworkName
  }
}
// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    name: '${namePrefix}${serviceShort}001'
    skuName: 'Standard_LRS'
    kind: 'StorageV2'
    largeFileSharesState: 'Enabled'
    enableHierarchicalNamespace: false
    supportsHttpsTrafficOnly: true
    enableNfsV3: false
    configureBlobService: true
    blobContainers: [
      {
        name: 'asbvmltest'
        enableNfsV3AllSquash: false
        enableNfsV3RootSquash: false
        publicAccess: 'None'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Reader'
            principalIds: [
              nestedDependencies.outputs.managedIdentityPrincipalId
            ]
            principalType: 'ServicePrincipal'
          }
        ]
      }
      {
        name: 'archivecontainer'
        publicAccess: 'None'
        metadata: {
          testKey: 'testValue'
        }
        enableWORM: true
        WORMRetention: 666
        allowProtectedAppendWrites: false
      }
    ]

    blobPrivateEndpointName: 'pe-${namePrefix}${serviceShort}001-blob'
    blobPrivateEndpointNicName: 'nic-pe-${namePrefix}${serviceShort}001-blob'
    blobPrivateEndpointAsgResourceIds: [
      nestedDependencies.outputs.asgResourceId
    ]
    privateEndpointVirtualNetworkResourceGroup: resourceGroupName
    privateEndpointVirtualNetworkName: virtualNetworkName
    privateEndpointSubnetName: nestedDependencies.outputs.subnetName
    systemAssignedIdentity: true
    userAssignedIdentities: [ nestedDependencies.outputs.managedIdentityResourceId ]
    tags: {
      Environment: 'Non-Prod'
      Role: 'ASBVML Deployment Validation'
    }
  }
}
