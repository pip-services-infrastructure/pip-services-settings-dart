import 'dart:async';

import 'package:pip_services_settings/src/data/version1/data.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

abstract class ISettingsController {
  /// Retrieves settings section ids filtered by set of criteria
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [filter]            data transfer object used to pass filter parameters as simple key-value pairs
  /// - [paging]            data transfer object to pass paging parameters for queries
  Future<DataPage<String>> getSectionIds(
      String correlationId, FilterParams filter, PagingParams paging);

  /// Retrieves settings sections filtered by set of criteria
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [filter]            data transfer object used to pass filter parameters as simple key-value pairs
  /// - [paging]            data transfer object to pass paging parameters for queries
  Future<DataPage<SettingsSectionV1>> getSections(
      String correlationId, FilterParams filter, PagingParams paging);

  /// Gets settings section by its unique id
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [id]                unique section id
  Future<ConfigParams> getSectionById(String correlationId, String id);

  /// Sets settings section by its unique id
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [id]                unique section id
  /// - [parameters]        new section parameters
  Future<ConfigParams> setSection(
      String correlationId, String id, ConfigParams parameters);

  /// Modify settings section, perform partial updates and increments
  ///
  /// - [correlation_id]        (optional) transaction id to trace execution through call chain.
  /// - [id]                    unique section id
  /// - [update_parameters]     section parameters for partial updates
  /// - [increment_parameters]  section parameters for increments
  Future<ConfigParams> modifySection(String correlationId, String id,
      ConfigParams updateParams, ConfigParams incrementParams);
}
