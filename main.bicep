@secure()
param vulnerabilityAssessments_Default_storageContainerPath string

@secure()
param vulnerabilityAssessments_Default_storageContainerPath_1 string
param vaults_az3kvname_name string = 'az3kvname'
param servers_de_prep_sql_server_name string = 'de-prep-sql-server'
param workflows_logic_app_de_prep_name string = 'logic_app_de_prep'
param storageAccounts_batchxstream_name string = 'batchxstream'
param workspaces_de_prep_50_synapse_name string = 'de-prep-50-synapse'
param workspaces_databricks_DE_prep_name string = 'databricks_DE_prep'
param accessConnectors_access_DE_prep_name string = 'access_DE_prep'
param BackupVaults_DE_prep_backup_vault_name string = 'DE-prep-backup-vault'
param userAssignedIdentities_DE_PREP_MANAGED_IDENTITY_name string = 'DE-PREP-MANAGED-IDENTITY'

resource accessConnectors_access_DE_prep_name_resource 'Microsoft.Databricks/accessConnectors@2026-01-01' = {
  name: accessConnectors_access_DE_prep_name
  location: 'uksouth'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

resource workspaces_databricks_DE_prep_name_resource 'Microsoft.Databricks/workspaces@2026-01-01' = {
  name: workspaces_databricks_DE_prep_name
  location: 'uksouth'
  sku: {
    name: 'trial'
  }
  properties: {
    computeMode: 'Hybrid'
    defaultCatalog: {
      initialType: 'UnityCatalog'
    }
    managedResourceGroupId: '/subscriptions/c8a7238d-5a6d-412f-b9db-a337a2a05efc/resourceGroups/Managed_DE_prep'
    parameters: {
      enableNoPublicIp: {
        type: 'Bool'
        value: true
      }
      prepareEncryption: {
        type: 'Bool'
        value: false
      }
      requireInfrastructureEncryption: {
        type: 'Bool'
        value: false
      }
      storageAccountName: {
        type: 'String'
        value: 'dbstoragewjsnwc2byin7m'
      }
      storageAccountSkuName: {
        type: 'String'
        value: 'Standard_ZRS'
      }
    }
    authorizations: [
      {
        principalId: '9a74af6f-d153-4348-988a-e2672920bee9'
        roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      }
    ]
    createdBy: {}
    updatedBy: {}
  }
}

resource BackupVaults_DE_prep_backup_vault_name_resource 'Microsoft.DataProtection/BackupVaults@2025-09-01' = {
  name: BackupVaults_DE_prep_backup_vault_name
  location: 'southindia'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    storageSettings: [
      {
        datastoreType: 'VaultStore'
        type: 'LocallyRedundant'
      }
    ]
    securitySettings: {
      softDeleteSettings: {
        state: 'On'
        retentionDurationInDays: json('14')
      }
    }
    replicatedRegions: []
  }
}

resource vaults_az3kvname_name_resource 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: vaults_az3kvname_name
  location: 'centralindia'
  properties: {
    sku: {
      family: 'A'
      name: 'Standard'
    }
    tenantId: '09dc2fc1-c9ac-4318-b3ee-152650ed6e63'
    accessPolicies: []
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    vaultUri: 'https://${vaults_az3kvname_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}

resource workflows_logic_app_de_prep_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_logic_app_de_prep_name
  location: 'centralindia'
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {}
      triggers: {}
      actions: {}
      outputs: {}
    }
    parameters: {}
  }
}

resource userAssignedIdentities_DE_PREP_MANAGED_IDENTITY_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: userAssignedIdentities_DE_PREP_MANAGED_IDENTITY_name
  location: 'southindia'
}

resource servers_de_prep_sql_server_name_resource 'Microsoft.Sql/servers@2024-11-01-preview' = {
  name: servers_de_prep_sql_server_name
  location: 'centralindia'
  kind: 'v12.0'
  properties: {
    administratorLogin: 'CloudSA3e4dc044'
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'User'
      login: 'dhawleyashpal@live.com'
      sid: 'e301e13a-405f-4933-9f45-d51cc7da4661'
      tenantId: '09dc2fc1-c9ac-4318-b3ee-152650ed6e63'
      azureADOnlyAuthentication: false
    }
    restrictOutboundNetworkAccess: 'Disabled'
    retentionDays: -1
  }
}

resource storageAccounts_batchxstream_name_resource 'Microsoft.Storage/storageAccounts@2025-06-01' = {
  name: storageAccounts_batchxstream_name
  location: 'southindia'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    isHnsEnabled: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource BackupVaults_DE_prep_backup_vault_name_backup_policy 'Microsoft.DataProtection/BackupVaults/backupPolicies@2025-09-01' = {
  parent: BackupVaults_DE_prep_backup_vault_name_resource
  name: 'backup-policy'
  properties: {
    policyRules: [
      {
        lifecycles: [
          {
            deleteAfter: {
              objectType: 'AbsoluteDeleteOption'
              duration: 'P7D'
            }
            targetDataStoreCopySettings: []
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
          }
        ]
        isDefault: true
        name: 'Default'
        objectType: 'AzureRetentionRule'
      }
      {
        backupParameters: {
          backupType: 'Discrete'
          objectType: 'AzureBackupParams'
        }
        trigger: {
          schedule: {
            repeatingTimeIntervals: [
              'R/2026-01-04T02:30:00+00:00/P1W'
            ]
            timeZone: 'Coordinated Universal Time'
          }
          taggingCriteria: [
            {
              tagInfo: {
                tagName: 'Default'
              }
              taggingPriority: 99
              isDefault: true
            }
          ]
          objectType: 'ScheduleBasedTriggerContext'
        }
        dataStore: {
          dataStoreType: 'VaultStore'
          objectType: 'DataStoreInfoBase'
        }
        name: 'BackupWeekly'
        objectType: 'AzureBackupRule'
      }
    ]
    datasourceTypes: [
      'Microsoft.Storage/storageAccounts/adlsBlobServices'
    ]
    objectType: 'BackupPolicy'
  }
}

resource BackupVaults_DE_prep_backup_vault_name_redundantxstorage 'Microsoft.DataProtection/BackupVaults/backupPolicies@2025-09-01' = {
  parent: BackupVaults_DE_prep_backup_vault_name_resource
  name: 'redundantxstorage'
  properties: {
    policyRules: [
      {
        lifecycles: [
          {
            deleteAfter: {
              objectType: 'AbsoluteDeleteOption'
              duration: 'P7D'
            }
            targetDataStoreCopySettings: []
            sourceDataStore: {
              dataStoreType: 'VaultStore'
              objectType: 'DataStoreInfoBase'
            }
          }
        ]
        isDefault: true
        name: 'Default'
        objectType: 'AzureRetentionRule'
      }
      {
        backupParameters: {
          backupType: 'Discrete'
          objectType: 'AzureBackupParams'
        }
        trigger: {
          schedule: {
            repeatingTimeIntervals: [
              'R/2026-01-04T00:30:00+00:00/P1W'
            ]
            timeZone: 'Coordinated Universal Time'
          }
          taggingCriteria: [
            {
              tagInfo: {
                tagName: 'Default'
              }
              taggingPriority: 99
              isDefault: true
            }
          ]
          objectType: 'ScheduleBasedTriggerContext'
        }
        dataStore: {
          dataStoreType: 'VaultStore'
          objectType: 'DataStoreInfoBase'
        }
        name: 'BackupWeekly'
        objectType: 'AzureBackupRule'
      }
    ]
    datasourceTypes: [
      'Microsoft.Storage/storageAccounts/adlsBlobServices'
    ]
    objectType: 'BackupPolicy'
  }
}

resource servers_de_prep_sql_server_name_ActiveDirectory 'Microsoft.Sql/servers/administrators@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'ActiveDirectory'
  properties: {
    administratorType: 'ActiveDirectory'
    login: 'dhawleyashpal@live.com'
    sid: 'e301e13a-405f-4933-9f45-d51cc7da4661'
    tenantId: '09dc2fc1-c9ac-4318-b3ee-152650ed6e63'
  }
}

resource servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource servers_de_prep_sql_server_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_de_prep_sql_server_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_de_prep_sql_server_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_de_prep_sql_server_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_de_prep_sql_server_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource Microsoft_Sql_servers_auditingPolicies_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  location: 'Central India'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/auditingSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Sql_servers_azureADOnlyAuthentications_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/azureADOnlyAuthentications@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    azureADOnlyAuthentication: false
  }
}

resource Microsoft_Sql_servers_connectionPolicies_servers_de_prep_sql_server_name_default 'Microsoft.Sql/servers/connectionPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'default'
  location: 'centralindia'
  properties: {
    connectionType: 'Default'
  }
}

resource servers_de_prep_sql_server_name_free_sql_db_3195963 'Microsoft.Sql/servers/databases@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'free-sql-db-3195963'
  location: 'centralindia'
  sku: {
    name: 'GP_S_Gen5'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 1
  }
  kind: 'v12.0,user,vcore,serverless,freelimit'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    autoPauseDelay: 60
    requestedBackupStorageRedundancy: 'Local'
    minCapacity: json('0.5')
    maintenanceConfigurationId: '/subscriptions/c8a7238d-5a6d-412f-b9db-a337a2a05efc/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    useFreeLimit: true
    freeLimitExhaustionBehavior: 'AutoPause'
    availabilityZone: 'NoPreference'
  }
}

resource servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  location: 'Central India'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource servers_de_prep_sql_server_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Current'
  properties: {}
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_de_prep_sql_server_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_de_prep_sql_server_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2024-11-01-preview' = {
  name: '${servers_de_prep_sql_server_name}/master/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_de_prep_sql_server_name_current 'Microsoft.Sql/servers/encryptionProtector@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'current'
  kind: 'servicemanaged'
  properties: {
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
    autoRotationEnabled: false
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_de_prep_sql_server_name_AllowAllWindowsAzureIps 'Microsoft.Sql/servers/firewallRules@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource servers_de_prep_sql_server_name_ClientIPAddress_2026_3_10_11_38_33 'Microsoft.Sql/servers/firewallRules@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'ClientIPAddress_2026-3-10_11-38-33'
  properties: {
    startIpAddress: '163.116.214.39'
    endIpAddress: '163.116.214.39'
  }
}

resource servers_de_prep_sql_server_name_ServiceManaged 'Microsoft.Sql/servers/keys@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'ServiceManaged'
  kind: 'servicemanaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource Microsoft_Sql_servers_sqlVulnerabilityAssessments_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/sqlVulnerabilityAssessments@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource Microsoft_Sql_servers_vulnerabilityAssessments_servers_de_prep_sql_server_name_Default 'Microsoft.Sql/servers/vulnerabilityAssessments@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource storageAccounts_batchxstream_name_default 'Microsoft.Storage/storageAccounts/blobServices@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_batchxstream_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_resource
  name: 'default'
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_batchxstream_name_storageAccounts_batchxstream_name_7254e9be_66b5_4e34_bf91_85cb8ef2363a 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_resource
  name: '${storageAccounts_batchxstream_name}.7254e9be-66b5-4e34-bf91-85cb8ef2363a'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Pending'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_batchxstream_name_default 'Microsoft.Storage/storageAccounts/queueServices@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_batchxstream_name_default 'Microsoft.Storage/storageAccounts/tableServices@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource workspaces_de_prep_50_synapse_name_resource 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaces_de_prep_50_synapse_name
  location: 'centralindia'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      resourceId: storageAccounts_batchxstream_name_resource.id
      createManagedPrivateEndpoint: true
      accountUrl: 'https://batchxstream.dfs.core.windows.net'
      filesystem: 'deprepfilesystemsynapse'
    }
    encryption: {}
    managedVirtualNetwork: 'default'
    managedResourceGroupName: 'DE-PREP-SYNAPSE'
    sqlAdministratorLogin: 'sqladminuser'
    privateEndpointConnections: []
    managedVirtualNetworkSettings: {
      preventDataExfiltration: false
      allowedAadTenantIdsForLinking: []
    }
    publicNetworkAccess: 'Enabled'
    cspWorkspaceAdminProperties: {
      initialWorkspaceAdminObjectId: 'e301e13a-405f-4933-9f45-d51cc7da4661'
    }
    azureADOnlyAuthentication: false
    trustedServiceBypassEnabled: true
  }
}

resource workspaces_de_prep_50_synapse_name_Default 'Microsoft.Synapse/workspaces/auditingSettings@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Synapse_workspaces_azureADOnlyAuthentications_workspaces_de_prep_50_synapse_name_default 'Microsoft.Synapse/workspaces/azureADOnlyAuthentications@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'default'
  properties: {
    azureADOnlyAuthentication: false
  }
}

resource Microsoft_Synapse_workspaces_dedicatedSQLminimalTlsSettings_workspaces_de_prep_50_synapse_name_default 'Microsoft.Synapse/workspaces/dedicatedSQLminimalTlsSettings@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'default'
  location: 'centralindia'
  properties: {
    minimalTlsVersion: '1.2'
  }
}

resource Microsoft_Synapse_workspaces_extendedAuditingSettings_workspaces_de_prep_50_synapse_name_Default 'Microsoft.Synapse/workspaces/extendedAuditingSettings@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource workspaces_de_prep_50_synapse_name_allowAll 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'allowAll'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource workspaces_de_prep_50_synapse_name_ClientIPAddress_2026_3_10_12_37_42 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'ClientIPAddress-2026-3-10-12-37-42'
  properties: {
    startIpAddress: '163.116.214.39'
    endIpAddress: '163.116.214.39'
  }
}

resource workspaces_de_prep_50_synapse_name_AutoResolveIntegrationRuntime 'Microsoft.Synapse/workspaces/integrationruntimes@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
    managedVirtualNetwork: {
      referenceName: 'default'
      type: 'ManagedVirtualNetworkReference'
      id: '12ea7887-a12c-464b-82db-a00d542b3096'
    }
  }
}

resource workspaces_de_prep_50_synapse_name_workspaces_de_prep_50_synapse_name_synapse_ws_sql_workspaces_de_prep_50_synapse_name_65ec6397_c497_4949_88b8_8ceae2d0df17 'Microsoft.Synapse/workspaces/privateEndpointConnections@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: '${workspaces_de_prep_50_synapse_name}.synapse-ws-sql--${workspaces_de_prep_50_synapse_name}-65ec6397-c497-4949-88b8-8ceae2d0df17'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Approved by Microsoft.Synapse Resource Provider'
    }
  }
}

resource workspaces_de_prep_50_synapse_name_workspaces_de_prep_50_synapse_name_synapse_ws_sqlOnDemand_workspaces_de_prep_50_synapse_name_2ca4641a_0774_4c16_99aa_2d2ca8da3e19 'Microsoft.Synapse/workspaces/privateEndpointConnections@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: '${workspaces_de_prep_50_synapse_name}.synapse-ws-sqlOnDemand--${workspaces_de_prep_50_synapse_name}-2ca4641a-0774-4c16-99aa-2d2ca8da3e19'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Approved by Microsoft.Synapse Resource Provider'
    }
  }
}

resource Microsoft_Synapse_workspaces_securityAlertPolicies_workspaces_de_prep_50_synapse_name_Default 'Microsoft.Synapse/workspaces/securityAlertPolicies@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource workspaces_de_prep_50_synapse_name_Az_syn_DW 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'Az_syn_DW'
  location: 'centralindia'
  sku: {
    name: 'DW100c'
    capacity: 0
  }
  properties: {
    maxSizeBytes: 263882790666240
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    storageAccountType: 'GRS'
    provisioningState: 'Succeeded'
  }
}

resource Microsoft_Synapse_workspaces_vulnerabilityAssessments_workspaces_de_prep_50_synapse_name_Default 'Microsoft.Synapse/workspaces/vulnerabilityAssessments@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath_1
  }
}

resource servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  location: 'Central India'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/auditingSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_de_prep_sql_server_name_free_sql_db_3195963_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'default'
  properties: {
    timeBasedImmutability: 'Disabled'
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_de_prep_sql_server_name_free_sql_db_3195963_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'default'
  properties: {
    retentionDays: 7
    diffBackupIntervalInHours: 12
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource servers_de_prep_sql_server_name_free_sql_db_3195963_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Current'
  properties: {}
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_de_prep_sql_server_name_free_sql_db_3195963_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Current'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_de_prep_sql_server_name_free_sql_db_3195963_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2024-11-01-preview' = {
  parent: servers_de_prep_sql_server_name_free_sql_db_3195963
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_de_prep_sql_server_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_adfstagedcommandtempdata 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'adfstagedcommandtempdata'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_bronze 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'bronze'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_databricksmetastore 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'databricksmetastore'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_deprepfilesystemsynapse 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'deprepfilesystemsynapse'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_gold 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'gold'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource storageAccounts_batchxstream_name_default_silver 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: storageAccounts_batchxstream_name_default
  name: 'silver'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_batchxstream_name_resource
  ]
}

resource workspaces_de_prep_50_synapse_name_Az_syn_DW_Default 'Microsoft.Synapse/workspaces/sqlPools/auditingSettings@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_extendedAuditingSettings_workspaces_de_prep_50_synapse_name_Az_syn_DW_Default 'Microsoft.Synapse/workspaces/sqlPools/extendedAuditingSettings@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_geoBackupPolicies_workspaces_de_prep_50_synapse_name_Az_syn_DW_Default 'Microsoft.Synapse/workspaces/sqlPools/geoBackupPolicies@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'Default'
  location: 'Central India'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_securityAlertPolicies_workspaces_de_prep_50_synapse_name_Az_syn_DW_Default 'Microsoft.Synapse/workspaces/sqlPools/securityAlertPolicies@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}

resource workspaces_de_prep_50_synapse_name_Az_syn_DW_current 'Microsoft.Synapse/workspaces/sqlPools/transparentDataEncryption@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'current'
  location: 'Central India'
  properties: {
    status: 'Disabled'
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_vulnerabilityAssessments_workspaces_de_prep_50_synapse_name_Az_syn_DW_Default 'Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments@2021-06-01' = {
  parent: workspaces_de_prep_50_synapse_name_Az_syn_DW
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    workspaces_de_prep_50_synapse_name_resource
  ]
}
