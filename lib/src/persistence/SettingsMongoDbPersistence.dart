import 'dart:async';
import 'package:pip_services3_mongodb/pip_services3_mongodb.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

class SettingsMongoDbPersistence
    extends IdentifiableMongoDbPersistence<SettingsSectionV1, String>
    implements ISettingsPersistence {
  SettingsMongoDbPersistence() : super('settings');

  static String fieldFromPublic(String field) {
    if (field == null) return null;
    field = field.replaceAll('.', '_dot_');
    return field;
  }

  static String fieldToPublic(String field) {
    if (field == null) return null;
    field = field.replaceAll('_dot_', '.');
    return field;
  }

  static Map<String, dynamic> mapToPublic(Map<String, dynamic> map) {
    return map?.map((key, value) => MapEntry(fieldToPublic(key), value));
  }

  static Map<String, dynamic> mapFromPublic(Map<String, dynamic> map) {
    return map?.map((key, value) => MapEntry(fieldFromPublic(key), value));
  }

  // Convert object to JSON format
  @override
  dynamic convertToPublic(Map<String, dynamic> value) {
    if (value == null) return null;

    var map = SettingsMongoDbPersistence.mapToPublic(value['parameters']);

    value = {
      'id': value['_id'],
      'parameters': ConfigParams.fromValue(map),
      'update_time': (value['update_time'] as DateTime)?.toIso8601String()
    };

    return super.convertToPublic(value);
  }

  @override
  Map<String, dynamic> convertFromPublic(dynamic value,
      {bool createUid = false}) {
    if (value == null) return null;

    var parameters = SettingsMongoDbPersistence.mapFromPublic(value.parameters);

    value = {
      '_id': value.id,
      'parameters': parameters,
      'update_time': value.update_time
    };

    value = super.convertFromPublic(value, createUid: createUid);

    return value;
  }

  dynamic composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();

    var criteria = [];

    var search = filter.getAsNullableString('search');
    if (search != null) {
      var searchRegex = RegExp(search, caseSensitive: false);
      criteria.add({
        '_id': {r'$regex': searchRegex.pattern}
      });
    }

    var id = filter.getAsNullableString('id');
    if (id != null) criteria.add({'_id': id});

    var idStarts = filter.getAsNullableString('id_starts');
    if (idStarts != null) {
      var idStartsRegex = RegExp(r'^' + idStarts, caseSensitive: false);
      criteria.add({
        '_id': {r'$regex': idStartsRegex.pattern}
      });
    }

    return criteria.isNotEmpty ? {r'$and': criteria} : {};
  }

  @override
  Future<DataPage<SettingsSectionV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super
        .getPageByFilterEx(correlationId, composeFilter(filter), paging, null);
  }

  @override
  Future<SettingsSectionV1> set(
      String correlationId, SettingsSectionV1 item) async {
    if (item == null) return Future.value(null);

    var parameters = item.parameters.getAsObject();
    parameters = SettingsMongoDbPersistence.mapFromPublic(parameters);

    var result = await collection.findAndModify(
        query: {'_id': item.id},
        update: {'parameters': item.parameters, 'update_time': DateTime.now()},
        returnNew: true,
        upsert: true);

    logger
        .trace(correlationId, 'Set in %s with id = %s', [collection, item.id]);

    var newItem = result != null ? convertToPublic(result) : null;
    return newItem;
  }

  @override
  Future<SettingsSectionV1> modify(String correlationId, String id,
      ConfigParams updateParams, ConfigParams incrementParams) async {
    var partial = <String, dynamic>{};
    partial[r'$set'] = <String, dynamic>{};
    partial[r'$set']['update_time'] = DateTime.now();

    // Update parameters
    if (updateParams != null) {
      for (var key in updateParams.keys) {
        if (updateParams.containsKey(key)) {
          var field =
              'parameters.' + SettingsMongoDbPersistence.fieldFromPublic(key);
          partial[r'$set'][field] = updateParams[key];
        }
      }
    }

    // Increment parameters
    if (incrementParams != null && incrementParams.isNotEmpty) {
      partial[r'$inc'] = <String, dynamic>{};
      for (var key in incrementParams.keys) {
        if (incrementParams.containsKey(key)) {
          var increment = incrementParams.getAsLongWithDefault(key, 0);
          var field =
              'parameters.' + SettingsMongoDbPersistence.fieldFromPublic(key);
          partial[r'$inc'][field] = increment;
        }
      }
    }

    var result = await collection.findAndModify(
        query: {'_id': id}, update: partial, returnNew: true, upsert: true);

    logger.trace(correlationId, 'Modified in %s by %s', [collection, id]);

    var newItem = result != null ? convertToPublic(result) : null;
    return newItem;
  }
}
