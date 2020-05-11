import 'dart:io';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/pip_services_settings.dart';
import 'package:test/test.dart';

import 'SettingsPersistenceFixture.dart';

void main() {
  group('SettingsMongoDbPersistence', () {
    SettingsMongoDbPersistence persistence;
    SettingsPersistenceFixture fixture;

    setUp(() async {
      var mongoUri = Platform.environment['MONGO_SERVICE_URI'];
      var mongoHost = Platform.environment['MONGO_SERVICE_HOST'] ?? 'localhost';
      var mongoPort = Platform.environment['MONGO_SERVICE_PORT'] ?? '27017';
      var mongoDatabase = Platform.environment['MONGO_SERVICE_DB'] ?? 'test';

      // Exit if mongo connection is not set
      if (mongoUri == '' && mongoHost == '') return;

      var dbConfig = ConfigParams.fromTuples([
        'connection.uri',
        mongoUri,
        'connection.host',
        mongoHost,
        'connection.port',
        mongoPort,
        'connection.database',
        mongoDatabase
      ]);

      persistence = SettingsMongoDbPersistence();
      persistence.configure(dbConfig);

      fixture = SettingsPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      await persistence.close(null);
    });

    test('Get and set', () async {
      await fixture.testGetAndSet();
    });

    test('Set parameter', () async {
      await fixture.testSetParameter();
    });

    test('Increment parameter', () async {
      await fixture.testIncrementParameter();
    });
  });
}
