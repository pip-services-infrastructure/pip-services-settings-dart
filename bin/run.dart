import 'package:pip_services_settings/pip_services_settings.dart';

void main(List<String> args)
{
	try
	{
    var proc = SettingsProcess();
		proc.configPath = './config/config.yml';
		proc.run(args);
	}
	catch (ex)
	{
		print(ex);
	}
}
