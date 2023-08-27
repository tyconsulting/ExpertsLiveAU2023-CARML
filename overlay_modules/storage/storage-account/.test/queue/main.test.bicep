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
param serviceShort string = 'ssaque'

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
    configureQueueService: true
    queues: [
      {
        name: 'queue1'
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
      }
      {
        name: 'queue2'
        metadata: {}
      }
    ]
    queuePrivateEndpointName: 'pe-${namePrefix}${serviceShort}001-queue'
    queuePrivateEndpointNicName: 'nic-pe-${namePrefix}${serviceShort}001-queue'
    queuePrivateEndpointAsgResourceIds: [
      nestedDependencies.outputs.asgResourceId
    ]
    privateEndpointVirtualNetworkResourceGroup: resourceGroupName
    privateEndpointVirtualNetworkName: virtualNetworkName
    privateEndpointSubnetName: nestedDependencies.outputs.subnetName
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'ASBVML Deployment Validation'
    }
  }
}
