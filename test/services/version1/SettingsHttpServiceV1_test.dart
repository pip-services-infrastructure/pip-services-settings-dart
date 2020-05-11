import 'dart:convert';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/pip_services_settings.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

var restConfig = ConfigParams.fromTuples([
  'connection.protocol',
  'http',
  'connection.host',
  'localhost',
  'connection.port',
  3000
]);

void main() {
  group('SettingsHttpServiceV1', () {
    SettingsHttpServiceV1 service;
    http.Client rest;
    String url;

    setUp(() async {
      url = 'http://localhost:3000';
      rest = http.Client();

      var persistence = SettingsMemoryPersistence();
      var controller = SettingsController();

      service = SettingsHttpServiceV1();
      service.configure(restConfig);

      var references = References.fromTuples([
        Descriptor(
            'pip-services-settings', 'persistence', 'memory', 'default', '1.0'),
        persistence,
        Descriptor(
            'pip-services-settings', 'controller', 'default', 'default', '1.0'),
        controller,
        Descriptor(
            'pip-services-settings', 'service', 'http', 'default', '1.0'),
        service
      ]);

      controller.setReferences(references);
      service.setReferences(references);

      await service.open(null);
    });

    tearDown(() async {
      await service.close(null);
    });

    test('CRUD Operations', () async {
      // Create one section
      var resp = await rest.post(url + '/v1/settings/set_section', headers: {
        'Content-Type': 'application/json'
      }, body: jsonEncode({
        'id': 'test.1',
        'parameters':
            ConfigParams.fromTuples(['key1', 'value11', 'key2', 'value12'])
      }));

      var parameters = ConfigParams(jsonDecode(resp.body));

      expect(parameters, isNotNull);
      expect(parameters['key1'], 'value11');

      // Create another section
      resp = await rest.post(url + '/v1/settings/modify_section', headers: {
        'Content-Type': 'application/json'
      }, body: jsonEncode({
        'id': 'test.2',
        'update_parameters': ConfigParams.fromTuples(['key1', 'value21']),
        'increment_parameters': ConfigParams.fromTuples(['key2', 1])
      }));

      parameters = ConfigParams(jsonDecode(resp.body));

      expect(parameters, isNotNull);

      expect(parameters['key1'], 'value21');
      expect(parameters['key2'], '1');

      // Get second section
      resp = await rest.post(url + '/v1/settings/get_section_by_id',
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'id': 'test.2'}));

      parameters = ConfigParams(jsonDecode(resp.body));

      expect(parameters, isNotNull);

      expect(parameters['key1'], 'value21');
      expect(parameters['key2'], '1');

      // Get all sections
      resp = await rest.post(url + '/v1/settings/get_sections',
          headers: {'Content-Type': 'application/json'}, body: '{}');

      var sectionsPage = DataPage<SettingsSectionV1>.fromJson(json.decode(resp.body),
          (item) {
        var event = SettingsSectionV1();
        event.fromJson(item);
        return event;
      });

      expect(sectionsPage, isNotNull);
      expect(sectionsPage.data.length, 2);

      // Get all section ids
      resp = await rest.post(url + '/v1/settings/get_section_ids',
          headers: {'Content-Type': 'application/json'}, body: '{}');

      var sectionIdsPage = DataPage<String>.fromJson(json.decode(resp.body), (item) { return item; });

      expect(sectionIdsPage, isNotNull);
      expect(sectionIdsPage.data.length, 2);
    });
  });
}
