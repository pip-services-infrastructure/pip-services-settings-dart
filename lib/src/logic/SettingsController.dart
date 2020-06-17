import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/src/data/version1/SettingsSectionV1.dart';
import 'package:pip_services_settings/src/persistence/ISettingsPersistence.dart';

import 'ISettingsController.dart';
import 'SettingsCommandSet.dart';

class SettingsController
    implements
        IConfigurable,
        IReferenceable,
        ICommandable,
        ISettingsController {
  static final ConfigParams _defaultConfig = ConfigParams.fromTuples([
    'dependencies.persistence',
    'pip-services-settings:persistence:*:*:1.0'
  ]);

  final DependencyResolver _dependencyResolver =
      DependencyResolver(SettingsController._defaultConfig);

  ISettingsPersistence _persistence;
  SettingsCommandSet _commandSet;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _dependencyResolver.configure(config);
  }

  /// Set references to component.
  ///
  /// - [references]    references parameters to be set.
  @override
  void setReferences(IReferences references) {
    _dependencyResolver.setReferences(references);
    _persistence =
        _dependencyResolver.getOneRequired<ISettingsPersistence>('persistence');
  }

  /// Gets a command set.
  ///
  /// Return Command set
  @override
  CommandSet getCommandSet() {
    _commandSet ??= SettingsCommandSet(this);
    return _commandSet;
  }

  /// Retrieves settings section ids filtered by set of criteria
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [filter]            data transfer object used to pass filter parameters as simple key-value pairs
  /// - [paging]            data transfer object to pass paging parameters for queries
  @override
  Future<DataPage<String>> getSectionIds(
      String correlationId, FilterParams filter, PagingParams paging) async {
    var page =
        await _persistence.getPageByFilter(correlationId, filter, paging);

    var data = <String>[];
    var total = 0;

    if (page != null) {
      total = page.total;
      for (var item in page.data) {
        data.add(item.id);
      }
      //data = page.data.map((x) => x.id);
    }

    return DataPage<String>(data, total);
  }

  /// Retrieves settings sections filtered by set of criteria
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [filter]            data transfer object used to pass filter parameters as simple key-value pairs
  /// - [paging]            data transfer object to pass paging parameters for queries
  @override
  Future<DataPage<SettingsSectionV1>> getSections(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return await _persistence.getPageByFilter(correlationId, filter, paging);
  }

  /// Gets settings section by its unique id
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [id]                unique section id
  @override
  Future<ConfigParams> getSectionById(String correlationId, String id) async {
    var result = await _persistence.getOneById(correlationId, id);
    return result?.parameters ?? ConfigParams();
  }

  /// Sets settings section by its unique id
  ///
  /// - [correlation_id]    (optional) unique id that identifies distributed transaction
  /// - [id]                unique section id
  /// - [parameters]        new section parameters
  @override
  Future<ConfigParams> setSection(
      String correlationId, String id, ConfigParams parameters) async {
    var item = SettingsSectionV1(
        id: id, parameters: parameters, update_time: DateTime.now());
    var result = await _persistence.set(correlationId, item);
    return result?.parameters;
  }

  /// Modify settings section, perform partial updates and increments
  ///
  /// - [correlation_id]        (optional) transaction id to trace execution through call chain.
  /// - [id]                    unique section id
  /// - [update_parameters]     section parameters for partial updates
  /// - [increment_parameters]  section parameters for increments
  @override
  Future<ConfigParams> modifySection(String correlationId, String id,
      ConfigParams updateParams, ConfigParams incrementParams) async {
    var result = await _persistence.modify(
        correlationId, id, updateParams, incrementParams);
    return result?.parameters;
  }
}
