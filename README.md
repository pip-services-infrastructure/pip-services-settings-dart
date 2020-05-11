# Settings Microservice

This is a settings microservice from Pip.Services library. 
It manages system settings separated by individual sections.
Each section contains multiple key-value parameter pairs. 

The microservice currently supports the following deployment options:
* Deployment platforms: Standalone Process
* External APIs: HTTP/REST
* Persistence: Flat Files, MongoDB

This microservice has no dependencies on other microservices.

<a name="links"></a> Quick Links:

* [Download Links](doc/Downloads.md)
* [Development Guide](doc/Development.md)
* [Configuration Guide](doc/Configuration.md)
* [Deployment Guide](doc/Deployment.md)
* Client SDKs
  - [Dart SDK](https://github.com/pip-services-infrastructure/pip-clients-settings-dart)
* Communication Protocols
  - [HTTP Version 1](doc/HttpProtocolV1.md)
  

## Contract

Logical contract of the microservice is presented below. For physical implementation (HTTP/REST, Thrift, Seneca, Lambda, etc.),
please, refer to documentation of the specific protocol.

```dart
class SettingsSectionV1 implements IStringIdentifiable {
  @override
  String id;
  ConfigParams parameters;
  DateTime update_time;

  SettingsSectionV1();
  SettingsSectionV1.from(String id, [ConfigParams parameters, DateTime update_time]);

  void fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}


abstract class ISettingsClientV1 {
  Future<DataPage<String>> getSectionIds(String correlationId, FilterParams filter, PagingParams paging);
  Future<DataPage<SettingsSectionV1>> getSections(String correlationId, FilterParams filter, PagingParams paging);
  Future<ConfigParams> getSectionById(String correlationId, String id);
  Future<ConfigParams> setSection(String correlationId, String id, ConfigParams parameters);
  Future<ConfigParams> modifySection(String correlationId, String id, ConfigParams updateParams, ConfigParams incrementParams);
}
```

## Download

Right now the only way to get the microservice is to check it out directly from github repository
```bash
git clone git@github.com:pip-services-infrastructure/pip-services-settings-dart.git
```

Pip.Service team is working to implement packaging and make stable releases available for your 
as zip downloadable archieves.

## Run

Add **config.yml** file to the root of the microservice folder and set configuration parameters.
As the starting point you can use example configuration from **config.example.yml** file. 

Example of microservice configuration
```yaml
- descriptor: "pip-services-container:container-info:default:default:1.0"
  name: "pip-services-settings"
  description: "Settings microservice"

- descriptor: "pip-services-commons:logger:console:default:1.0"
  level: "trace"

- descriptor: "pip-services-settings:persistence:file:default:1.0"
  path: "./data/settings.json"

- descriptor: "pip-services-settings:controller:default:default:1.0"

- descriptor: "pip-services-settings:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 8080
```
 
For more information on the microservice configuration see [Configuration Guide](Configuration.md).

Start the microservice using the command:
```bash
dart ./bin/run.dart
```

## Use

The easiest way to work with the microservice is to use client SDK. 
The complete list of available client SDKs for different languages is listed in the [Quick Links](#links)

If you use dart, then get references to the required libraries:
- Pip.Services3.Commons : https://github.com/pip-services3-dart/pip-services3-commons-dart
- Pip.Services3.Rpc: https://github.com/pip-services3-dart/pip-services3-rpc-dart

Add **pip-services3-commons-dart** and **pip_clients_settings** packages
```dart
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_clients_settings/pip_clients_settings.dart';
```

Define client configuration parameters that match configuration of the microservice external API
```dart
// Client configuration
var httpConfig = ConfigParams.fromTuples(
	"connection.protocol", "http",
	"connection.host", "localhost",
	"connection.port", 8080
);
```

Instantiate the client and open connection to the microservice
```dart
// Create the client instance
var client = SettingsHttpClientV1();

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

## Acknowledgements

This microservice was created and currently maintained by *Sergey Seroukhov*.

