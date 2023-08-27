@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

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

resource managedIdentity1 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${managedIdentityName}-1'
  location: location
}

resource managedIdentity2 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: '${managedIdentityName}-2'
  location: location
}

resource asg 'Microsoft.Network/applicationSecurityGroups@2023-02-01' = {
  name: asgName
  location: location
}

@description('The principal ID of the first created Managed Identity.')
output managedIdentity1PrincipalId string = managedIdentity1.properties.principalId

@description('The resource ID of the first created Managed Identity.')
output managedIdentity1ResourceId string = managedIdentity1.id

@description('The principal ID of the second created Managed Identity.')
output managedIdentity2PrincipalId string = managedIdentity2.properties.principalId

@description('The resource ID of the second created Managed Identity.')
output managedIdentity2ResourceId string = managedIdentity2.id

@description('The resource ID of the created Application Security Group.')
output asgResourceId string = asg.id

@description('The name of the created Virtual Network Subnet.')
output subnetName string = virtualNetwork.properties.subnets[0].name
