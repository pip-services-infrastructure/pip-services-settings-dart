import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_rpc/pip_services3_rpc.dart';

class SettingsHttpServiceV1 extends CommandableHttpService {
  SettingsHttpServiceV1() : super('v1/settings') {
    dependencyResolver.put(
        'controller',
        Descriptor(
            'pip-services-settings', 'controller', 'default', '*', '1.0'));
  }
}
