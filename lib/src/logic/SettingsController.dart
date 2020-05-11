
import 'dart:async';

import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services_settings/src/data/version1/SettingsSectionV1.dart';
import 'package:pip_services_settings/src/persistence/ISettingsPersistence.dart';

import 'ISettingsController.dart';
import 'SettingsCommandSet.dart';

class SettingsController implements IConfigurable, IReferenceable, ICommandable, ISettingsController {
    static final ConfigParams _defaultConfig = ConfigParams.fromTuples(
        ['dependencies.persistence', 'pip-services-settings:persistence:*:*:1.0']
    );

    DependencyResolver _dependencyResolver = new DependencyResolver(SettingsController._defaultConfig);
    
    ISettingsPersistence _persistence;
    SettingsCommandSet _commandSet;

    @override
	  void configure(ConfigParams config) {
        this._dependencyResolver.configure(config);
    }

    @override
	  void setReferences(IReferences references)
    {
        this._dependencyResolver.setReferences(references);
        this._persistence = this._dependencyResolver.getOneRequired<ISettingsPersistence>('persistence');
    }

@override
	CommandSet getCommandSet()
	{
	    _commandSet ??= SettingsCommandSet(this);
	    return _commandSet;
	}

    Future<DataPage<String>> getSectionIds(String correlationId, FilterParams filter, PagingParams paging) async {
        var page = await this._persistence.getPageByFilter(correlationId, filter, paging);
        
        List<String> data = [];
        int total = 0;

        if (page != null) {
            total = page.total;
            for (var item in page.data) {
              data.add(item.id);
            }
            //data = page.data.map((x) => x.id);
        }

        return new DataPage<String>(data, total);
    }

    Future<DataPage<SettingsSectionV1>> getSections(String correlationId, FilterParams filter, PagingParams paging) async { 
        return await this._persistence.getPageByFilter(correlationId, filter, paging);
    }

    Future<ConfigParams> getSectionById(String correlationId, String id) async {
        var result = await this._persistence.getOneById(correlationId, id);
        return result?.parameters ?? new ConfigParams();
    }

    Future<ConfigParams> setSection(String correlationId, String id, ConfigParams parameters) async {
        var item = new SettingsSectionV1.from(id, parameters);
        var result = await this._persistence.set(correlationId, item);
        return result?.parameters;
    }

    Future<ConfigParams> modifySection(String correlationId, String id, ConfigParams updateParams, ConfigParams incrementParams) async {
        var result = await this._persistence.modify(correlationId, id, updateParams, incrementParams);
        return result?.parameters;
    }
    
}
