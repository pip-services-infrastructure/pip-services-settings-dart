
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

class SettingsServiceFactory extends Factory {
  
  // static final Descriptor = Descriptor("pip-services-Settings", "factory", "default", "default", "1.0");
  static final MemoryPersistenceDescriptor = Descriptor("pip-services-settings", "persistence", "memory", "*", "1.0");
  static final FilePersistenceDescriptor = Descriptor("pip-services-settings", "persistence", "file", "*", "1.0");
  static final MongoDbPersistenceDescriptor = Descriptor("pip-services-settings", "persistence", "mongodb", "*", "1.0");
  static final ControllerDescriptor = Descriptor("pip-services-settings", "controller", "default", "*", "1.0");
  static final HttpServiceDescriptor = Descriptor("pip-services-settings", "service", "http", "*", "1.0");

  SettingsServiceFactory() : super() {
    this.registerAsType(SettingsServiceFactory.MemoryPersistenceDescriptor, SettingsMemoryPersistence);
    this.registerAsType(SettingsServiceFactory.FilePersistenceDescriptor, SettingsFilePersistence);
    this.registerAsType(SettingsServiceFactory.MongoDbPersistenceDescriptor, SettingsMongoDbPersistence);
    this.registerAsType(SettingsServiceFactory.ControllerDescriptor, SettingsController);
    this.registerAsType(SettingsServiceFactory.HttpServiceDescriptor, SettingsHttpServiceV1);
  }
}
