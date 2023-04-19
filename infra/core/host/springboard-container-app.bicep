param name string
param location string = resourceGroup().location
param tags object = {}

param containerAppsEnvironmentName string = ''
param serviceType string = ''
param keyVaultName string = ''

resource app 'Microsoft.App/containerApps@2022-11-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    managedEnvironmentId: containerAppsEnvironment.id
    configuration: {
      service: {
        type: serviceType
      }
    }
    template: {
      containers: [
        {
          name: name
          image: serviceType
        }
      ]
    }
  }
}

resource containerAppsEnvironment 'Microsoft.App/managedEnvironments@2022-03-01' existing = {
  name: containerAppsEnvironmentName
}

//resource pgAdminPasswordSecret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//  parent: keyVault
//  name: 'pgsqlAdminPassword'
//  properties: {
//    value: pgpwd
//  }
//}

//resource sqlAzureConnectionStringSercret 'Microsoft.KeyVault/vaults/secrets@2022-07-01' = {
//  parent: keyVault
//  name: connectionStringKey
//  properties: {
//    value: connectionString
//  }
//}

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: keyVaultName
}

output serviceBind object = {
  serviceId: app.id
  name: name
}

//var pgpwd = app.properties.configuration.secrets[0].name.value
//var pgpwd = app.properties.configuration.secrets[0].name 
output app object = app
output name string = app.name
