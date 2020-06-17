import 'package:pip_services3_commons/pip_services3_commons.dart';

class SettingsSectionV1 implements IStringIdentifiable {
  @override
  String id;
  ConfigParams parameters;
  DateTime update_time;

  SettingsSectionV1({String id, ConfigParams parameters, DateTime update_time})
      : id = id,
        parameters = parameters ?? ConfigParams(),
        update_time = update_time;

  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parameters = ConfigParams(json['parameters']);
    update_time = DateTime.tryParse(json['update_time']);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'parameters': parameters,
      'update_time': update_time.toIso8601String(),
    };
  }
}
