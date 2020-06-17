import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

abstract class ISettingsPersistence
    implements IGetter<SettingsSectionV1, String>, ISetter<SettingsSectionV1> {
  Future<DataPage<SettingsSectionV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging);
  Future<SettingsSectionV1> modify(String correlationId, String id,
      ConfigParams updateParams, ConfigParams incrementParams);
}
