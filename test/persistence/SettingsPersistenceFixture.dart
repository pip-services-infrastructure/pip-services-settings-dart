import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/pip_services_settings.dart';
import 'package:test/test.dart';

class SettingsPersistenceFixture {
  ISettingsPersistence _persistence;

  SettingsPersistenceFixture(persistence) {
    expect(persistence, isNotNull);
    _persistence = persistence;
  }

  void testGetAndSet() async {
    var settings = await _persistence.set(
        null,
        SettingsSectionV1(
            id: 'test.1',
            parameters: ConfigParams.fromTuples(
                ['key1', 'value11', 'key2', 'value12'])));

    expect(settings, isNotNull);
    expect(settings.id, 'test.1');
    expect(settings.parameters.getAsString('key1'), 'value11');

    settings = await _persistence.set(
        null,
        SettingsSectionV1(
            id: 'test.2',
            parameters: ConfigParams.fromTuples(
                ['key1', 'value21', 'key2', 'value22'])));

    expect(settings, isNotNull);
    expect(settings.id, 'test.2');
    expect(settings.parameters.getAsString('key1'), 'value21');

    settings = await _persistence.getOneById(null, 'test.1');

    expect(settings, isNotNull);
    expect(settings.id, 'test.1');
    expect(settings.parameters.getAsString('key1'), 'value11');

    var page = await _persistence.getPageByFilter(
        null, FilterParams.fromTuples(['id_starts', 'test']), null);

    expect(page.data.length, 2);
  }

  void testSetParameter() async {
    var settings = await _persistence.modify(
        null, 'test.1', ConfigParams.fromTuples(['key1', 'value11a']), null);
    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('value11a', settings.parameters.getAsString('key1'));

    settings = await _persistence.modify(
        null, 'test.1', ConfigParams.fromTuples(['key1', 'value11b']), null);
    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('value11b', settings.parameters.getAsString('key1'));

    settings = await _persistence.getOneById(null, 'test.1');

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('value11b', settings.parameters.getAsString('key1'));

    settings = await _persistence.modify(null, 'test.1',
        ConfigParams.fromTuples(['key1.key11', 'value11a']), null);

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('value11a', settings.parameters.getAsString('key1.key11'));
  }

  void testIncrementParameter() async {
    var settings = await _persistence.modify(
        null, 'test.1', null, ConfigParams.fromTuples(['key1', 1]));

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('1', settings.parameters.getAsString('key1'));

    settings = await _persistence.modify(
        null, 'test.1', null, ConfigParams.fromTuples(['key1', 2]));

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('3', settings.parameters.getAsString('key1'));

    settings = await _persistence.getOneById(null, 'test.1');

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('3', settings.parameters.getAsString('key1'));
  }

  void testGetSections() async {
    var settings = await _persistence.set(
        null,
        SettingsSectionV1(
            id: 'test.1',
            parameters: ConfigParams.fromTuples(
                ['key1', 'value11', 'key2', 'value12'])));

    expect(settings, isNotNull);
    expect('test.1', settings.id);
    expect('value11', settings.parameters.getAsString('key1'));

    var page = await _persistence.getPageByFilter(
        null, FilterParams(), PagingParams(0, 10, true));

    expect(page.data.length, 1);
  }
}
