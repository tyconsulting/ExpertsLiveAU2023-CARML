# Overlay Bicep Module - Storage Account `[Microsoft.Storage/storageAccounts]`

This module deploys a standardised Azure Storage Account that aligns with Contoso's security requirements.

## Navigation

- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Deployment examples](#Deployment-examples)

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Storage Account. |
| `privateEndpointSubnetName` | string | Existing Private Endpoint Subnet name. |
| `privateEndpointVirtualNetworkName` | string | Existing Private Endpoint Virtual Network name. |
| `privateEndpointVirtualNetworkResourceGroup` | string | Existing Private Endpoint Virtual Network Resoruce Group name. |

**Conditional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `blobPrivateEndpointAsgResourceIds` | array | `[]` | The resource IDs of the Application Security Groups (ASGs) for the blob Private Endpoint. Required if ASGs are required to be attached to the blob private endpoint. |
| `blobPrivateEndpointName` | string | `''` | Name of the blob Private Endpoint. Required for the blob private endpoint. Required if private endpoint for blob is required. |
| `filePrivateEndpointAsgResourceIds` | array | `[]` | The resource IDs of the Application Security Groups (ASGs) for the file Private Endpoint. Required if ASGs are required to be attached to the file private endpoint. |
| `filePrivateEndpointName` | string | `''` | Name of the file Private Endpoint. Required for the file Private Endpoint. Required if private endpoint for file is required. |
| `queuePrivateEndpointAsgResourceIds` | array | `[]` | The resource IDs of the Application Security Groups (ASGs) for the queue Private Endpoint. Required if ASGs are required to be attached to the queue private endpoint. |
| `queuePrivateEndpointName` | string | `''` | Name of the queue Private Endpoint. Required for the queue Private Endpoint. Required if private endpoint for queue is required. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `accessTier` | string | `'Hot'` | `[Cool, Hot]` | Storage Account Access Tier. |
| `azureFilesIdentityBasedAuthentication` | object | `{object}` |  | Provides the identity based authentication settings for Azure Files. |
| `blobContainers` | array | `[]` |  | list of blob containers to be created in the Storage Account. |
| `blobDeleteRetentionPolicy` | bool | `True` |  | Indicates whether DeleteRetentionPolicy is enabled for the Blob service. |
| `blobDeleteRetentionPolicyDays` | int | `7` |  | Indicates the number of days that the deleted blob should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `blobPrivateEndpointIP` | string | `''` |  | The static private IP address for the blob private endpoint. |
| `blobPrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the blob private endpoint. |
| `configureBlobService` | bool | `True` |  | Specify if blob service should be configured. Default value is set to true. |
| `configureFileService` | bool | `False` |  | Specify if file service should be configured. Default value is set to false. |
| `configureQueueService` | bool | `False` |  | Specify if queue service should be configured. Default value is set to false. |
| `customDomainName` | string | `''` |  | Sets the custom domain name assigned to the storage account. Name is the CNAME source. |
| `customDomainUseSubDomainName` | bool | `False` |  | Indicates whether indirect CName validation is enabled. This should only be set on updates. |
| `defaultToOAuthAuthentication` | bool | `False` |  | A boolean flag which indicates whether the default authentication is OAuth or not. |
| `enableHierarchicalNamespace` | bool | `False` |  | Enable Hierarchical Namespace. Default is set to false. It must be set to true to enable SFTP. This is automatically enabled if enableSFTP is set to true. |
| `enableNfsV3` | bool | `False` |  | If true, enables NFS 3.0 support for the storage account. Requires enableHierarchicalNamespace to be true. |
| `fileDeleteRetentionPolicy` | bool | `True` |  | Indicates whether DeleteRetentionPolicy is enabled for the File service. |
| `fileDeleteRetentionPolicyDays` | int | `7` |  | Indicates the number of days that the deleted file shares should be retained. The minimum specified value can be 1 and the maximum value can be 365. |
| `filePrivateEndpointIP` | string | `''` |  | The static private IP address for the file private endpoint. |
| `filePrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the file private endpoint. |
| `fileShares` | array | `[]` |  | list of file shares to be created in the Storage Account. |
| `kind` | string | `'StorageV2'` | `[BlobStorage, FileStorage, StorageV2]` | Type of Storage Account to create. |
| `largeFileSharesState` | string | `'Disabled'` | `[Disabled, Enabled]` | Allow large file shares if sets to 'Enabled'. It cannot be disabled once it is enabled. Only supported on locally redundant and zone redundant file shares. It cannot be set on FileStorage storage accounts (storage accounts for premium file shares). |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `managementPoliciesRules` | array | `[]` |  | The Storage Account ManagementPolicies Rules. |
| `queuePrivateEndpointIP` | string | `''` |  | The static private IP address for the queue private endpoint. |
| `queuePrivateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the queue private endpoint. |
| `queues` | array | `[]` |  | list of queues to be created in the Storage Account. |
| `skuName` | string | `'Standard_LRS'` | `[Premium_LRS, Premium_ZRS, Standard_GRS, Standard_GZRS, Standard_LRS, Standard_RAGRS, Standard_RAGZRS, Standard_ZRS]` | Storage Account Sku Name. |
| `supportsHttpsTrafficOnly` | bool | `True` |  | Allows HTTPS traffic only to storage service if sets to true. This must be set to true unless the storage account is hosting NFS shares. The default value is true. |
| `systemAssignedIdentity` | bool | `False` |  | Enables system assigned managed identity on the resource. |
| `tags` | object | `{object}` |  | Tags of the resource. |
| `userAssignedIdentities` | array | `[]` |  | The ID(s) to assign to the resource. |


### Parameter Usage: `tags`

Tag names and tag values can be provided as needed. A tag can be left without a value.

<details>

<summary>Parameter JSON format</summary>

```json
"tags": {
    "value": {
        "Environment": "Non-Prod",
        "Contact": "test.user@testcompany.com",
        "PurchaseOrder": "1234",
        "CostCenter": "7890",
        "ServiceName": "DeploymentValidation",
        "Role": "DeploymentValidation"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
tags: {
    Environment: 'Non-Prod'
    Contact: 'test.user@testcompany.com'
    PurchaseOrder: '1234'
    CostCenter: '7890'
    ServiceName: 'DeploymentValidation'
    Role: 'DeploymentValidation'
}
```

</details>
<p>

### Parameter Usage: `userAssignedIdentities`

You can specify multiple user assigned identities to a resource by providing additional resource IDs using the following format:

<details>

<summary>Parameter JSON format</summary>

```json
"userAssignedIdentities": {
    "value": {
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001": {},
        "/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002": {}
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
userAssignedIdentities: {
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-001': {}
    '/subscriptions/<<subscriptionId>>/resourcegroups/validation-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/adp-sxx-az-msi-x-002': {}
}
```

</details>
<p>

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed storage account. |
| `primaryBlobEndpoint` | string | The primary blob endpoint reference if blob services are deployed. |
| `resourceGroupName` | string | The resource group of the deployed storage account. |
| `resourceId` | string | The resource ID of the deployed storage account. |
| `systemAssignedPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `carml_modules/storage/storage-accounts` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Blob</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './storage/storage-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssablob'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssablob001'
    privateEndpointSubnetName: '<privateEndpointSubnetName>'
    privateEndpointVirtualNetworkName: '<privateEndpointVirtualNetworkName>'
    privateEndpointVirtualNetworkResourceGroup: '<privateEndpointVirtualNetworkResourceGroup>'
    // Non-required parameters
    blobContainers: [
      {
        enableNfsV3AllSquash: false
        enableNfsV3RootSquash: false
        name: 'Contosovmltest'
        publicAccess: 'None'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentityPrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
      }
      {
        allowProtectedAppendWrites: false
        enableWORM: true
        metadata: {
          testKey: 'testValue'
        }
        name: 'archivecontainer'
        publicAccess: 'None'
        WORMRetention: 666
      }
    ]
    blobPrivateEndpointAsgResourceIds: [
      '<asgResourceId>'
    ]
    blobPrivateEndpointName: 'pe-<<namePrefix>>ssablob001-blob'
    blobPrivateEndpointNicName: 'nic-pe-<<namePrefix>>ssablob001-blob'
    configureBlobService: true
    enableHierarchicalNamespace: false
    enableNfsV3: false
    kind: 'StorageV2'
    largeFileSharesState: 'Enabled'
    skuName: 'Standard_LRS'
    supportsHttpsTrafficOnly: true
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'ContosoVML Deployment Validation'
    }
    userAssignedIdentities: '<userAssignedIdentities>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>ssablob001"
    },
    "privateEndpointSubnetName": {
      "value": "<privateEndpointSubnetName>"
    },
    "privateEndpointVirtualNetworkName": {
      "value": "<privateEndpointVirtualNetworkName>"
    },
    "privateEndpointVirtualNetworkResourceGroup": {
      "value": "<privateEndpointVirtualNetworkResourceGroup>"
    },
    // Non-required parameters
    "blobContainers": {
      "value": [
        {
          "enableNfsV3AllSquash": false,
          "enableNfsV3RootSquash": false,
          "name": "Contosovmltest",
          "publicAccess": "None",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentityPrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ]
        },
        {
          "allowProtectedAppendWrites": false,
          "enableWORM": true,
          "metadata": {
            "testKey": "testValue"
          },
          "name": "archivecontainer",
          "publicAccess": "None",
          "WORMRetention": 666
        }
      ]
    },
    "blobPrivateEndpointAsgResourceIds": {
      "value": [
        "<asgResourceId>"
      ]
    },
    "blobPrivateEndpointName": {
      "value": "pe-<<namePrefix>>ssablob001-blob"
    },
    "blobPrivateEndpointNicName": {
      "value": "nic-pe-<<namePrefix>>ssablob001-blob"
    },
    "configureBlobService": {
      "value": true
    },
    "enableHierarchicalNamespace": {
      "value": false
    },
    "enableNfsV3": {
      "value": false
    },
    "kind": {
      "value": "StorageV2"
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "supportsHttpsTrafficOnly": {
      "value": true
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "ContosoVML Deployment Validation"
      }
    },
    "userAssignedIdentities": {
      "value": "<userAssignedIdentities>"
    }
  }
}
```

</details>
<p>

<h3>Example 2: File</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './storage/storage-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssafile'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssafile001'
    privateEndpointSubnetName: '<privateEndpointSubnetName>'
    privateEndpointVirtualNetworkName: '<privateEndpointVirtualNetworkName>'
    privateEndpointVirtualNetworkResourceGroup: '<privateEndpointVirtualNetworkResourceGroup>'
    // Non-required parameters
    configureFileService: true
    enableHierarchicalNamespace: false
    enableNfsV3: false
    filePrivateEndpointAsgResourceIds: [
      '<asgResourceId>'
    ]
    filePrivateEndpointName: 'pe-<<namePrefix>>ssafile001-file'
    filePrivateEndpointNicName: 'nic-pe-<<namePrefix>>ssafile001-file'
    fileShares: [
      {
        accessTier: 'Hot'
        name: 'Contosovml1'
        roleAssignments: [
          {
            principalIds: [
              '<managedIdentity1PrincipalId>'
              '<managedIdentity2PrincipalId>'
            ]
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        shareQuota: 5120
      }
      {
        name: 'Contosovml2'
        shareQuota: 102400
      }
    ]
    kind: 'StorageV2'
    largeFileSharesState: 'Enabled'
    skuName: 'Standard_LRS'
    supportsHttpsTrafficOnly: true
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'ContosoVML Deployment Validation'
    }
    userAssignedIdentities: [
      '<managedIdentity1ResourceId>'
      '<managedIdentity2ResourceId>'
    ]
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>ssafile001"
    },
    "privateEndpointSubnetName": {
      "value": "<privateEndpointSubnetName>"
    },
    "privateEndpointVirtualNetworkName": {
      "value": "<privateEndpointVirtualNetworkName>"
    },
    "privateEndpointVirtualNetworkResourceGroup": {
      "value": "<privateEndpointVirtualNetworkResourceGroup>"
    },
    // Non-required parameters
    "configureFileService": {
      "value": true
    },
    "enableHierarchicalNamespace": {
      "value": false
    },
    "enableNfsV3": {
      "value": false
    },
    "filePrivateEndpointAsgResourceIds": {
      "value": [
        "<asgResourceId>"
      ]
    },
    "filePrivateEndpointName": {
      "value": "pe-<<namePrefix>>ssafile001-file"
    },
    "filePrivateEndpointNicName": {
      "value": "nic-pe-<<namePrefix>>ssafile001-file"
    },
    "fileShares": {
      "value": [
        {
          "accessTier": "Hot",
          "name": "Contosovml1",
          "roleAssignments": [
            {
              "principalIds": [
                "<managedIdentity1PrincipalId>",
                "<managedIdentity2PrincipalId>"
              ],
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "shareQuota": 5120
        },
        {
          "name": "Contosovml2",
          "shareQuota": 102400
        }
      ]
    },
    "kind": {
      "value": "StorageV2"
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "supportsHttpsTrafficOnly": {
      "value": true
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "ContosoVML Deployment Validation"
      }
    },
    "userAssignedIdentities": {
      "value": [
        "<managedIdentity1ResourceId>",
        "<managedIdentity2ResourceId>"
      ]
    }
  }
}
```

</details>
<p>

<h3>Example 3: Queue</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module storageAccounts './storage/storage-accounts/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-ssaque'
  params: {
    // Required parameters
    name: '<<namePrefix>>ssaque001'
    privateEndpointSubnetName: '<privateEndpointSubnetName>'
    privateEndpointVirtualNetworkName: '<privateEndpointVirtualNetworkName>'
    privateEndpointVirtualNetworkResourceGroup: '<privateEndpointVirtualNetworkResourceGroup>'
    // Non-required parameters
    configureQueueService: true
    enableHierarchicalNamespace: false
    enableNfsV3: false
    kind: 'StorageV2'
    largeFileSharesState: 'Enabled'
    queuePrivateEndpointAsgResourceIds: [
      '<asgResourceId>'
    ]
    queuePrivateEndpointName: 'pe-<<namePrefix>>ssaque001-queue'
    queuePrivateEndpointNicName: 'nic-pe-<<namePrefix>>ssaque001-queue'
    queues: [
      {
        metadata: {
          key1: 'value1'
          key2: 'value2'
        }
        name: 'queue1'
      }
      {
        metadata: {}
        name: 'queue2'
      }
    ]
    skuName: 'Standard_LRS'
    supportsHttpsTrafficOnly: true
    systemAssignedIdentity: true
    tags: {
      Environment: 'Non-Prod'
      Role: 'ContosoVML Deployment Validation'
    }
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "<<namePrefix>>ssaque001"
    },
    "privateEndpointSubnetName": {
      "value": "<privateEndpointSubnetName>"
    },
    "privateEndpointVirtualNetworkName": {
      "value": "<privateEndpointVirtualNetworkName>"
    },
    "privateEndpointVirtualNetworkResourceGroup": {
      "value": "<privateEndpointVirtualNetworkResourceGroup>"
    },
    // Non-required parameters
    "configureQueueService": {
      "value": true
    },
    "enableHierarchicalNamespace": {
      "value": false
    },
    "enableNfsV3": {
      "value": false
    },
    "kind": {
      "value": "StorageV2"
    },
    "largeFileSharesState": {
      "value": "Enabled"
    },
    "queuePrivateEndpointAsgResourceIds": {
      "value": [
        "<asgResourceId>"
      ]
    },
    "queuePrivateEndpointName": {
      "value": "pe-<<namePrefix>>ssaque001-queue"
    },
    "queuePrivateEndpointNicName": {
      "value": "nic-pe-<<namePrefix>>ssaque001-queue"
    },
    "queues": {
      "value": [
        {
          "metadata": {
            "key1": "value1",
            "key2": "value2"
          },
          "name": "queue1"
        },
        {
          "metadata": {},
          "name": "queue2"
        }
      ]
    },
    "skuName": {
      "value": "Standard_LRS"
    },
    "supportsHttpsTrafficOnly": {
      "value": true
    },
    "systemAssignedIdentity": {
      "value": true
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "ContosoVML Deployment Validation"
      }
    }
  }
}
```

</details>
<p>
