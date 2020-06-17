# Examples for Settings Microservice

This is a settings microservice from Pip.Services library. It manages system settings separated by individual sections.
Each section contains multiple key-value parameter pairs. 

Define configuration parameters that match the configuration of the microservice's external API
```dart
// Service/Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the service
```dart
controller = SettingsController();
controller.configure(ConfigParams());

service = SettingsHttpServiceV1();
service.configure(httpConfig);

persistence = SettingsMemoryPersistence();

var references = References.fromTuples([
    Descriptor('pip-services-settings', 'persistence', 'memory', 'default', '1.0'), persistence,
    Descriptor('pip-services-settings', 'controller', 'default', 'default', '1.0'), controller,
    Descriptor('pip-services-settings', 'service', 'http', 'default', '1.0'), service
]);

controller.setReferences(references);
service.setReferences(references);

await controller.open(null);
await service.open(null);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = SettingsHttpClientV1(config);

// Configure the client
client.configure(httpConfig);

// Connect to the microservice
try{
  await client.open(null)
}catch() {
  // Error handling...
}       
// Work with the microservice
// ...
```

Now the client is ready to perform operations
```dart
var parameters = ConfigParams.fromTuples([
                    'myapp', ConfigParams.fromTuples([
                      'theme', 'blue',
                      'language', 'en'
                    ])
                 ]);

// Sets section parameters
client.setSection(
    null,
    '123',
    parameters
);
```

```dart
// Get section parameters
var parameters = client.getSectionById(
    null,
    '123'
);
``` 

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services-infrastructure/pip-services-settings-dart/tree/master/test).
