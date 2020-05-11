import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

class SettingsMemoryPersistence
    extends IdentifiableMemoryPersistence<SettingsSectionV1, String>
    implements ISettingsPersistence {
  SettingsMemoryPersistence() : super() {}

  bool matchString(String value, String search) {
    if (value == null && search == null) return true;
    if (value == null || search == null) return false;
    return value.toLowerCase().indexOf(search) >= 0;
  }

  dynamic composeFilter(FilterParams filter) {
    filter = filter ?? FilterParams();
    var search = filter.getAsNullableString('search');
    var id = filter.getAsNullableString('id');
    var idStarts = filter.getAsNullableString('id_starts');

    return (item) {
      if (search != null && !this.matchString(item.id, search)) return false;
      if (id != null && id != item.id) return false;
      if (idStarts != null && !item.id.startsWith(idStarts)) return false;
      return true;
    };
  }

  @override
  Future<DataPage<SettingsSectionV1>> getPageByFilter(
      String correlationId, FilterParams filter, PagingParams paging) async {
    return super.getPageByFilterEx(
        correlationId, this.composeFilter(filter), paging, null);
  }

  @override
  Future<SettingsSectionV1> set(
      String correlationId, SettingsSectionV1 item) async {
    if (item == null) return Future.value(null);

    // Update time
    item.update_time = DateTime.now();

    return super.set(correlationId, item);
  }

  @override
  Future<SettingsSectionV1> modify(String correlationId, String id,
      ConfigParams updateParams, ConfigParams incrementParams) async {
    var index = this.items.indexWhere((x) => x.id == id);

    SettingsSectionV1 item =
        index >= 0 ? this.items[index] : new SettingsSectionV1.from(id);

    // Update parameters
    if (updateParams != null) {
      for (var key in updateParams.keys) {
        if (updateParams.containsKey(key))
          item.parameters.setAsObject(key, updateParams[key]);
      }
    }

    // Increment parameters
    if (incrementParams != null) {
      for (var key in incrementParams.keys) {
        if (incrementParams.containsKey(key)) {
          var increment = incrementParams.getAsLongWithDefault(key, 0);
          var value = item.parameters.getAsLongWithDefault(key, 0);
          value += increment;
          item.parameters.setAsObject(key, value);
        }
      }
    }

    // Update time
    item.update_time = DateTime.now();

    if (index < 0) this.items.add(item);

    this.logger.trace(correlationId, "Modified item by %s", [id]);

    await this.save(correlationId);

    return Future.value(item);
  }
}
