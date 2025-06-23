{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "virtualNetworks_aro_vnet_mc95ijjw_name": {
            "defaultValue": "aro-vnet-mc95ijjw",
            "type": "String"
        },
        "networkSecurityGroups_quarkus_azure_cluster_82pv6_nsg_externalid": {
            "defaultValue": "/subscriptions/1fed20f5-d2d6-44bd-aab8-f98f5916a4fa/resourceGroups/aro-infra-mc95jm5p-quarkus-azure-cluster/providers/Microsoft.Network/networkSecurityGroups/quarkus-azure-cluster-82pv6-nsg",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2024-05-01",
            "name": "[parameters('virtualNetworks_aro_vnet_mc95ijjw_name')]",
            "location": "eastus",
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.0.0.0/23"
                    ]
                },
                "privateEndpointVNetPolicies": "Disabled",
                "subnets": [
                    {
                        "name": "master-subnet",
                        "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_aro_vnet_mc95ijjw_name'), 'master-subnet')]",
                        "properties": {
                            "addressPrefix": "10.0.0.0/27",
                            "networkSecurityGroup": {
                                "id": "[parameters('networkSecurityGroups_quarkus_azure_cluster_82pv6_nsg_externalid')]"
                            },
                            "serviceEndpoints": [
                                {
                                    "service": "Microsoft.ContainerRegistry",
                                    "locations": [
                                        "*"
                                    ]
                                }
                            ],
                            "delegations": [],
                            "privateEndpointNetworkPolicies": "Disabled",
                            "privateLinkServiceNetworkPolicies": "Disabled"
                        },
                        "type": "Microsoft.Network/virtualNetworks/subnets"
                    },
                    {
                        "name": "worker-subnet",
                        "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_aro_vnet_mc95ijjw_name'), 'worker-subnet')]",
                        "properties": {
                            "addressPrefix": "10.0.0.128/25",
                            "networkSecurityGroup": {
                                "id": "[parameters('networkSecurityGroups_quarkus_azure_cluster_82pv6_nsg_externalid')]"
                            },
                            "serviceEndpoints": [
                                {
                                    "service": "Microsoft.ContainerRegistry",
                                    "locations": [
                                        "*"
                                    ]
                                }
                            ],
                            "delegations": [],
                            "privateEndpointNetworkPolicies": "Disabled",
                            "privateLinkServiceNetworkPolicies": "Enabled"
                        },
                        "type": "Microsoft.Network/virtualNetworks/subnets"
                    }
                ],
                "virtualNetworkPeerings": [],
                "enableDdosProtection": false
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks/subnets",
            "apiVersion": "2024-05-01",
            "name": "[concat(parameters('virtualNetworks_aro_vnet_mc95ijjw_name'), '/master-subnet')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_aro_vnet_mc95ijjw_name'))]"
            ],
            "properties": {
                "addressPrefix": "10.0.0.0/27",
                "networkSecurityGroup": {
                    "id": "[parameters('networkSecurityGroups_quarkus_azure_cluster_82pv6_nsg_externalid')]"
                },
                "serviceEndpoints": [
                    {
                        "service": "Microsoft.ContainerRegistry",
                        "locations": [
                            "*"
                        ]
                    }
                ],
                "delegations": [],
                "privateEndpointNetworkPolicies": "Disabled",
                "privateLinkServiceNetworkPolicies": "Disabled"
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks/subnets",
            "apiVersion": "2024-05-01",
            "name": "[concat(parameters('virtualNetworks_aro_vnet_mc95ijjw_name'), '/worker-subnet')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_aro_vnet_mc95ijjw_name'))]"
            ],
            "properties": {
                "addressPrefix": "10.0.0.128/25",
                "networkSecurityGroup": {
                    "id": "[parameters('networkSecurityGroups_quarkus_azure_cluster_82pv6_nsg_externalid')]"
                },
                "serviceEndpoints": [
                    {
                        "service": "Microsoft.ContainerRegistry",
                        "locations": [
                            "*"
                        ]
                    }
                ],
                "delegations": [],
                "privateEndpointNetworkPolicies": "Disabled",
                "privateLinkServiceNetworkPolicies": "Enabled"
            }
        }
    ]
}
