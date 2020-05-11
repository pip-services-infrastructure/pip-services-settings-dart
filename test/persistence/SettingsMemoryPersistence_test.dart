import 'package:pip_services_settings/pip_services_settings.dart';
import 'package:test/test.dart';

import 'SettingsPersistenceFixture.dart';

void main() {
  group('SettingsMemoryPersistence', () {
    SettingsMemoryPersistence persistence;
    SettingsPersistenceFixture fixture;

    setUp(() async {
      persistence = SettingsMemoryPersistence();
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
