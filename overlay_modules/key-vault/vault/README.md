# Overlay Bicep Module - Key Vaults `[Microsoft.KeyVault/vaults]`

This module deploys a standardised Azure Key Vault that aligns with Contoso's security requirements.

## Navigation

- [Overlay Bicep Module - Key Vaults `[Microsoft.KeyVault/vaults]`](#overlay-bicep-module---key-vaults-microsoftkeyvaultvaults)
  - [Navigation](#navigation)
  - [Parameters](#parameters)
    - [Parameter Usage: `tags`](#parameter-usage-tags)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)
  - [Deployment examples](#deployment-examples)

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the Key Vault. Must be globally unique. |
| `privateEndpointName` | string | The name of the private endpoint. |
| `privateEndpointSubnetName` | string | Existing Private Endpoint Subnet name. |
| `privateEndpointVirtualNetworkName` | string | Existing Private Endpoint Virtual Network name. |
| `privateEndpointVirtualNetworkResourceGroup` | string | Existing Private Endpoint Virtual Network Resoruce Group name. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateEndpointAsgResourceIds` | array | The resource IDs of the Application Security Groups (ASGs) for the private endpoint. Required if ASGs are required to be attached to the private endpoint. |

**Optional parameters**

| Parameter Name | Type | Default Value | Allowed Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `enableVaultForDeployment` | bool | `False` |  | Specifies if the vault is enabled for deployment by script or compute. Default is set to false. |
| `enableVaultForDiskEncryption` | bool | `False` |  | Specifies if the azure platform has access to the vault for enabling disk encryption scenarios. Default is set to false. |
| `enableVaultForTemplateDeployment` | bool | `False` |  | Specifies if the vault is enabled for a template deployment. Default is set to false. |
| `keys` | array | `[]` |  | All keys to create. |
| `location` | string | `[resourceGroup().location]` |  | Location for all resources. |
| `networkRuleSetBypass` | string | `'None'` | `[AzureServices, None]` | Indicates what traffic can bypass network rules. This can be 'AzureServices' or 'None'. It must be set to 'AzureServices' if 'enableVaultForDeployment' or 'enableVaultForTemplateDeployment' are set to true. Default value is set to 'None'.. |
| `privateEndpointIP` | string | `''` |  | The static privavte IP address for the private endpoint. |
| `privateEndpointNicName` | string | `''` |  | The custom name of the network interface attached to the private endpoint. |
| `secrets` | secureObject | `{object}` |  | All secrets to create. |
| `tags` | object | `{object}` |  | Tags of the resource. |


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

## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the key vault. |
| `resourceGroupName` | string | The name of the resource group the key vault was created in. |
| `resourceId` | string | The resource ID of the key vault. |
| `uri` | string | The URI of the key vault. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `carml_modules/key-vault/vaults` | Local reference |

## Deployment examples

The following module usage examples are retrieved from the content of the files hosted in the module's `.test` folder.
   >**Note**: The name of each example is based on the name of the file from which it is taken.

   >**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

<h3>Example 1: Common</h3>

<details>

<summary>via Bicep module</summary>

```bicep
module vaults './key-vault/vaults/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-kvvcom'
  params: {
    name: '<name>'
    privateEndpointName: '<privateEndpointName>'
    privateEndpointSubnetName: '<privateEndpointSubnetName>'
    privateEndpointVirtualNetworkName: '<privateEndpointVirtualNetworkName>'
    privateEndpointVirtualNetworkResourceGroup: '<privateEndpointVirtualNetworkResourceGroup>'
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: false
    enableVaultForTemplateDeployment: true
    keys: [
      {
        attributesExp: 1725109032
        attributesNbf: 10000
        name: 'keyName'
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
      }
    ]
    networkRuleSetBypass: 'AzureServices'
    privateEndpointAsgResourceIds: [
      '<asgResourceId>'
    ]
    privateEndpointNicName: '<privateEndpointNicName>'
    secrets: {
      secureList: [
        {
          attributesExp: 1702648632
          attributesNbf: 10000
          contentType: 'string'
          name: 'secretName'
          value: 'secretValue'
        }
      ]
    }
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
    "name": {
      "value": "<name>"
    },
    "privateEndpointName": {
      "value": "<privateEndpointName>"
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
    "enableVaultForDeployment": {
      "value": true
    },
    "enableVaultForDiskEncryption": {
      "value": false
    },
    "enableVaultForTemplateDeployment": {
      "value": true
    },
    "keys": {
      "value": [
        {
          "attributesExp": 1725109032,
          "attributesNbf": 10000,
          "name": "keyName",
          "rotationPolicy": {
            "attributes": {
              "expiryTime": "P2Y"
            },
            "lifetimeActions": [
              {
                "action": {
                  "type": "Rotate"
                },
                "trigger": {
                  "timeBeforeExpiry": "P2M"
                }
              },
              {
                "action": {
                  "type": "Notify"
                },
                "trigger": {
                  "timeBeforeExpiry": "P30D"
                }
              }
            ]
          }
        }
      ]
    },
    "networkRuleSetBypass": {
      "value": "AzureServices"
    },
    "privateEndpointAsgResourceIds": {
      "value": [
        "<asgResourceId>"
      ]
    },
    "privateEndpointNicName": {
      "value": "<privateEndpointNicName>"
    },
    "secrets": {
      "value": {
        "secureList": [
          {
            "attributesExp": 1702648632,
            "attributesNbf": 10000,
            "contentType": "string",
            "name": "secretName",
            "value": "secretValue"
          }
        ]
      }
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
