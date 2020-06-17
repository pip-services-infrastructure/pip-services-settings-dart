import 'package:pip_services3_container/pip_services3_container.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';
import 'package:pip_services_settings/pip_services_settings.dart';

class SettingsProcess extends ProcessContainer {
  SettingsProcess() : super('settings', 'Settings microservice') {
    factories.add(SettingsServiceFactory());
    factories.add(DefaultRpcFactory());
  }
}
