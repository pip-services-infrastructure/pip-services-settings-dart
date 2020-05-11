
import 'dart:async';

import 'package:pip_services_settings/src/data/version1/data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

abstract class ISettingsController {
  Future<DataPage<String>> getSectionIds(String correlationId, FilterParams filter, PagingParams paging);
  Future<DataPage<SettingsSectionV1>> getSections(String correlationId, FilterParams filter, PagingParams paging);
  Future<ConfigParams> getSectionById(String correlationId, String id);
  Future<ConfigParams> setSection(String correlationId, String id, ConfigParams parameters);
  Future<ConfigParams> modifySection(String correlationId, String id, ConfigParams updateParams, ConfigParams incrementParams);
}
