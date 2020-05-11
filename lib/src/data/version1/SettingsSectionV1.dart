import 'package:pip_services3_commons/pip_services3_commons.dart';

class SettingsSectionV1 implements IStringIdentifiable {
  @override
  String id;
  ConfigParams parameters;
  DateTime update_time;

  SettingsSectionV1();

  SettingsSectionV1.from(String id, [ConfigParams parameters, DateTime update_time]) {
    this.id = id;
    this.parameters = parameters ?? ConfigParams();
    this.update_time = update_time ?? DateTime.now();
  }

	void fromJson(Map<String, dynamic> json)
	{
		id = json['id'];
    parameters = ConfigParams(json['parameters']);
		update_time = DateTime.tryParse(json['update_time']);
	}

	Map<String, dynamic> toJson()
	{
		return <String, dynamic>
		{
			'id': id,
      'parameters' : parameters,
			'update_time': update_time.toIso8601String(),
		};
	}
}
