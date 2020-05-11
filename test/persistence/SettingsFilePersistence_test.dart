import 'package:pip_services_settings/pip_services_settings.dart';
import 'package:test/test.dart';

import 'SettingsPersistenceFixture.dart';

void main() {
  group('SettingsFilePersistence', () {
    SettingsFilePersistence persistence;
    SettingsPersistenceFixture fixture;

    setUp(() async {
      persistence = SettingsFilePersistence('./data/settings.test.json');

      fixture = SettingsPersistenceFixture(persistence);

      await persistence.open(null);
      await persistence.clear(null);
    });

    tearDown(() async {
      persistence.close(null);
    });

    test('Get and set', () async {
      fixture.testGetAndSet();
    });

    test('Set parameter', () async {
      fixture.testSetParameter();
    });

    test('Increment parameter', () async {
      fixture.testIncrementParameter();
    });
  });
}
