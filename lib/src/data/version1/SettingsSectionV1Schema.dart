import 'package:pip_services3_commons/pip_services3_commons.dart';

class SettingsSectionV1Schema extends ObjectSchema {
  SettingsSectionV1Schema() : super() {
    withRequiredProperty('id', TypeCode.String);
    withOptionalProperty('parameters', TypeCode.Map);
    withOptionalProperty('update_time', null);
  }
}
