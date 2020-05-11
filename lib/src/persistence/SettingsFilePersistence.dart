import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_data/pip_services3_data.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

class SettingsFilePersistence extends SettingsMemoryPersistence {
  JsonFilePersister<SettingsSectionV1> _persister;
  SettingsFilePersistence([String path]) : super() {
    this._persister = new JsonFilePersister<SettingsSectionV1>(path);
    this.loader = this._persister;
    this.saver = this._persister;
  }

  @override
  void configure(ConfigParams config) {
    super.configure(config);
    this._persister.configure(config);
  }
}
