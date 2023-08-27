@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Application Security Group to create.')
param asgName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: addressPrefix
        }
      }
    ]
  }
}

resource asg 'Microsoft.Network/applicationSecurityGroups@2023-02-01' = {
  name: asgName
  location: location
}

@description('The resource ID of the created Application Security Group.')
output asgResourceId string = asg.id

@description('The name of the created Virtual Network Subnet.')
output subnetName string = virtualNetwork.properties.subnets[0].name
