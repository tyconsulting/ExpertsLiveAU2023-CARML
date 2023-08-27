@description('Required. Name of the Storage Account.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@allowed([
  'Hot'
  'Cool'
])
@description('Optional. Storage Account Access Tier.')
param accessTier string = 'Hot'

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
@description('Optional. Storage Account Sku Name.')
param skuName string = 'Standard_LRS'

@allowed([
  'StorageV2'
  'BlobStorage'
  'FileStorage'
])
@description('Optional. Type of Storage Account to create.')
param kind string = 'StorageV2'

@description('Optional. The Storage Account ManagementPolicies Rules.')
param managementPoliciesRules array = []

@description('Optional. Enable Hierarchical Namespace. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true.')
param enableHierarchicalNamespace bool = false

@description('Optional. Allows HTTPS traffic only to storage service if sets to true. This must be set to true unless the storage account is hosting NFS shares. The default value is true.')
param supportsHttpsTrafficOnly bool = true

@description('Optional. Specify if blob service should be configured. Default value is set to true.')
param configureBlobService bool = true

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the Blob service.')
param blobDeleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param blobDeleteRetentionPolicyDays int = 7

@description('Optional. Specify if file service should be configured. Default value is set to false.')
param configureFileService bool = false

@description('Optional. Indicates whether DeleteRetentionPolicy is enabled for the File service.')
param fileDeleteRetentionPolicy bool = true

@description('Optional. Indicates the number of days that the deleted file shares should be retained. The minimum specified value can be 1 and the maximum value can be 365.')
param fileDeleteRetentionPolicyDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Allow large file shares if sets to \'Enabled\'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares).')
param largeFileSharesState string = 'Disabled'

@description('Optional. Provides the identity based authentication settings for Azure Files.')
param azureFilesIdentityBasedAuthentication object = {}

@description('Optional. Sets the custom domain name assigned to the storage account. Name is the CNAME source.')
param customDomainName string = ''

@description('Optional. Indicates whether indirect CName validation is enabled. This should only be set on updates.')
param customDomainUseSubDomainName bool = false

@description('Optional. A boolean flag which indicates whether the default authentication is OAuth or not.')
param defaultToOAuthAuthentication bool = false

@description('Optional. Specify if queue service should be configured. Default value is set to false.')
param configureQueueService bool = false

@description('Conditional. Name of the blob Private Endpoint. Required for the blob private endpoint. Required if private endpoint for blob is required.')
param blobPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the blob private endpoint.')
param blobPrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the blob private endpoint.')
param blobPrivateEndpointIP string = ''

@description('Conditional. The resource IDs of the Application Security Groups (ASGs) for the blob Private Endpoint. Required if ASGs are required to be attached to the blob private endpoint.')
param blobPrivateEndpointAsgResourceIds array = []

@description('Conditional. Name of the file Private Endpoint. Required for the file Private Endpoint. Required if private endpoint for file is required.')
param filePrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the file private endpoint.')
param filePrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the file private endpoint.')
param filePrivateEndpointIP string = ''

@description('Conditional. The resource IDs of the Application Security Groups (ASGs) for the file Private Endpoint. Required if ASGs are required to be attached to the file private endpoint.')
param filePrivateEndpointAsgResourceIds array = []

@description('Conditional. Name of the queue Private Endpoint. Required for the queue Private Endpoint. Required if private endpoint for queue is required.')
param queuePrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the queue private endpoint.')
param queuePrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the queue private endpoint.')
param queuePrivateEndpointIP string = ''

@description('Conditional. The resource IDs of the Application Security Groups (ASGs) for the queue Private Endpoint. Required if ASGs are required to be attached to the queue private endpoint.')
param queuePrivateEndpointAsgResourceIds array = []

@description('Conditional. Name of the dfs Private Endpoint. Required for the queue Private Endpoint. Required if private endpoint for queue is required.')
param dfsPrivateEndpointName string = ''

@description('Optional. The custom name of the network interface attached to the dfs private endpoint.')
param dfsPrivateEndpointNicName string = ''

@description('Optional. The static private IP address for the dfs private endpoint.')
param dfsPrivateEndpointIP string = ''

@description('Conditional. The resource IDs of the Application Security Groups (ASGs) for the dfs Private Endpoint. Required if ASGs are required to be attached to the queue private endpoint.')
param dfsPrivateEndpointAsgResourceIds array = []

@description('Optional. list of blob containers to be created in the Storage Account.')
param blobContainers array = []

@description('Optional. list of file shares to be created in the Storage Account.')
param fileShares array = []

@description('Optional. list of queues to be created in the Storage Account.')
param queues array = []

@description('Optional. If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true.')
param enableNfsV3 bool = false

@description('Required. Existing Private Endpoint Virtual Network Resoruce Group name.')
param privateEndpointVirtualNetworkResourceGroup string

@description('Required. Existing Private Endpoint Virtual Network name.')
param privateEndpointVirtualNetworkName string

@description('Required. Existing Private Endpoint Subnet name.')
param privateEndpointSubnetName string

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities array = []

var moduleVersion = loadJsonContent('./version.json').version

var mergedTags = union(tags, {
    'hidden-module_name': 'storage/storage-accounts'
    'hidden-module_version': moduleVersion
  })

var blobPeAsgs = [for asg in blobPrivateEndpointAsgResourceIds: {
  id: asg
}]
var filePeAsgs = [for asg in filePrivateEndpointAsgResourceIds: {
  id: asg
}]
var queuePeAsgs = [for asg in queuePrivateEndpointAsgResourceIds: {
  id: asg
}]
var dfsPeAsgs = [for asg in dfsPrivateEndpointAsgResourceIds: {
  id: asg
}]
var blobPe = !empty(blobPrivateEndpointName) ? [
  {
    name: blobPrivateEndpointName
    service: 'blob'
    subnetResourceId: peVnet::peSubnet.id
    applicationSecurityGroups: !empty(blobPrivateEndpointAsgResourceIds) ? blobPeAsgs : null
    customNetworkInterfaceName: !empty(blobPrivateEndpointNicName) ? blobPrivateEndpointNicName : null
    tags: tags
    ipConfigurations: !empty(blobPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'blob'
          memberName: 'blob'
          privateIPAddress: blobPrivateEndpointIP
        }
      }
    ] : any(null)
  }
] : []

var queuePe = !empty(queuePrivateEndpointName) ? [
  {
    name: queuePrivateEndpointName
    service: 'queue'
    subnetResourceId: peVnet::peSubnet.id
    applicationSecurityGroups: !empty(queuePrivateEndpointAsgResourceIds) ? queuePeAsgs : null
    customNetworkInterfaceName: !empty(queuePrivateEndpointNicName) ? queuePrivateEndpointNicName : null
    tags: tags
    ipConfigurations: !empty(blobPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'queue'
          memberName: 'queue'
          privateIPAddress: queuePrivateEndpointIP
        }
      }
    ] : any(null)
  }
] : []

var filePe = !empty(filePrivateEndpointName) ? [
  {
    name: filePrivateEndpointName
    service: 'file'
    subnetResourceId: peVnet::peSubnet.id
    applicationSecurityGroups: !empty(filePrivateEndpointAsgResourceIds) ? filePeAsgs : null
    customNetworkInterfaceName: !empty(filePrivateEndpointNicName) ? filePrivateEndpointNicName : null
    tags: tags
    ipConfigurations: !empty(filePrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'file'
          memberName: 'file'
          privateIPAddress: filePrivateEndpointIP
        }
      }
    ] : any(null)
  }
] : []

var dfsPe = !empty(dfsPrivateEndpointName) ? [
  {
    name: dfsPrivateEndpointName
    service: 'dfs'
    subnetResourceId: peVnet::peSubnet.id
    applicationSecurityGroups: !empty(dfsPrivateEndpointAsgResourceIds) ? dfsPeAsgs : null
    customNetworkInterfaceName: !empty(dfsPrivateEndpointNicName) ? dfsPrivateEndpointNicName : null
    tags: tags
    ipConfigurations: !empty(dfsPrivateEndpointIP) ? [
      {
        name: 'ipconfig1'
        properties: {
          groupId: 'dfs'
          memberName: 'dfs'
          privateIPAddress: dfsPrivateEndpointIP
        }
      }
    ] : any(null)
  }
] : []
var combinedPes = concat(blobPe, queuePe, filePe, dfsPe)

// ---------- Lookup Private Endpoint subnet ----------

resource peVnet 'microsoft.network/virtualNetworks@2022-07-01' existing = {
  name: privateEndpointVirtualNetworkName
  scope: resourceGroup(privateEndpointVirtualNetworkResourceGroup)

  resource peSubnet 'subnets' existing = {
    name: privateEndpointSubnetName
  }
}
module standardStorageAccount '../../../carml_modules/storage/storage-account/main.bicep' = {
  name: take('ASBStorage-${name}', 64)
  dependsOn: []
  params: {
    name: name
    location: location
    tags: mergedTags
    systemAssignedIdentity: systemAssignedIdentity
    userAssignedIdentities: toObject(userAssignedIdentities, entry => entry, entry => {})
    kind: kind
    skuName: skuName
    accessTier: accessTier
    largeFileSharesState: largeFileSharesState
    azureFilesIdentityBasedAuthentication: azureFilesIdentityBasedAuthentication
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    allowSharedKeyAccess: false
    privateEndpoints: combinedPes
    managementPolicyRules: managementPoliciesRules
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'None'
      ipRules: []
      virtualNetworkRules: []
    }
    requireInfrastructureEncryption: true
    allowCrossTenantReplication: false
    customDomainName: customDomainName
    customDomainUseSubDomainName: customDomainUseSubDomainName
    blobServices: configureBlobService ? {
      containers: blobContainers
      deleteRetentionPolicy: blobDeleteRetentionPolicy
      deleteRetentionPolicyDays: blobDeleteRetentionPolicyDays
    } : {}
    fileServices: configureFileService ? {
      shares: fileShares
      shareDeleteRetentionPolicy: {
        enabled: fileDeleteRetentionPolicy
        days: fileDeleteRetentionPolicyDays
      }
      protocolSettings: {
        smb: {
          authenticationMethods: 'Kerberos'
          channelEncryption: 'AES-256-GCM'
          kerberosTicketEncryption: 'AES-256'
          multichannel: kind == 'FileStorage' && startsWith(skuName, 'Premium') ? {
            enabled: true
          } : any(null)
          versions: 'SMB3.0;SMB3.1.1'
        }
      }
    } : {}
    queueServices: configureQueueService ? {
      queues: queues
    } : {}

    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    enableHierarchicalNamespace: enableHierarchicalNamespace
    enableSftp: false
    isLocalUserEnabled: false
    localUsers: any(null)
    enableNfsV3: enableNfsV3
    allowedCopyScope: 'AAD'
    publicNetworkAccess: 'Disabled'
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    enableDefaultTelemetry: false
  }
}

@description('The resource ID of the deployed storage account.')
output resourceId string = standardStorageAccount.outputs.resourceId

@description('The name of the deployed storage account.')
output name string = standardStorageAccount.outputs.name

@description('The resource group of the deployed storage account.')
output resourceGroupName string = resourceGroup().name

@description('The primary blob endpoint reference if blob services are deployed.')
output primaryBlobEndpoint string = standardStorageAccount.outputs.primaryBlobEndpoint

@description('The principal ID of the system assigned identity.')
output systemAssignedPrincipalId string = standardStorageAccount.outputs.systemAssignedPrincipalId

@description('The location the resource was deployed into.')
output location string = standardStorageAccount.outputs.location
