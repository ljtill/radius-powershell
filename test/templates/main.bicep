import radius as rad

param environmentName string
param applicationName string
param containerName string

resource environment 'Applications.Core/environments@2023-10-01-preview' existing = {
  name: environmentName
}

resource application 'Applications.Core/applications@2023-10-01-preview' = {
  name: applicationName
  properties: {
    environment: environment.id
    extensions: [
      {
        kind: 'kubernetesNamespace'
        namespace: 'apps-default'
      }
    ]
  }
}

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: containerName
  properties: {
    application: application.id
    container: {
      image: 'radius.azurecr.io/samples/demo:latest'
      ports: {
        web: {
          containerPort: 3000
        }
      }
    }
  }
}
