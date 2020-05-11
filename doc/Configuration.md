# Configuration Guide <br/> Settings Microservice

Configuration structure used by this module follows the 
[standard configuration](https://github.com/pip-services/pip-services/blob/master/usage/Configuration.md) 
structure.

Example **config.yml** file:

```yaml
- descriptor: "pip-services-container:container-info:default:default:1.0"
  name: "pip-services-settings"
  description: "settings microservice"

- descriptor: "pip-services-commons:logger:console:default:1.0"
  level: "trace"

- descriptor: "pip-services-settings:persistence:file:default:1.0"
  path: "./data/settings.json"

- descriptor: "pip-services-settings:controller:default:default:1.0"

- descriptor: "pip-services-settings:service:http:default:1.0"
  connection:
    protocol: "http"
    host: "0.0.0.0"
    port: 3000
```
