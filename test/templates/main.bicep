import radius as rad

resource environment 'Applications.Core/environments@2023-10-01-preview' existing = {
  name: 'tests'
}

resource application 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'tests'
  properties: {
    environment: environment.id
  }
}

resource database 'Applications.Datastores/mongoDatabases@2023-10-01-preview' = {
  name: 'tests'
  properties: {
    environment: environment.id
    application: application.id
  }
}

resource container 'Applications.Core/containers@2023-10-01-preview' = {
  name: 'tests'
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
    connections: {
      mongodb: {
        source: database.id
      }
    }
  }
}
