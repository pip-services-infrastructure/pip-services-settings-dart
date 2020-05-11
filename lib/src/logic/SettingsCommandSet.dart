
import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'ISettingsController.dart';

class SettingsCommandSet extends CommandSet {
    ISettingsController _controller;

    SettingsCommandSet(ISettingsController controller) : super() {
        this._controller = controller;

        // Register commands to the database
      this.addCommand(this.makeGetSectionIdsCommand());
      this.addCommand(this.makeGetSectionsCommand());
      this.addCommand(this.makeGetSectionByIdCommand());
      this.addCommand(this.makeSetSectionCommand());
      this.addCommand(this.makeModifySectionCommand());
    }

	ICommand makeGetSectionIdsCommand() {
		return new Command(
			"get_section_ids",
			new ObjectSchema(true)
				.withOptionalProperty('filter', new FilterParamsSchema())
				.withOptionalProperty('paging', new PagingParamsSchema()),
        (String correlationId, Parameters args)
	        {
	            var filter = FilterParams.fromValue(args.get('filter'));
	            var paging = PagingParams.fromValue(args.get('paging'));
	            return _controller.getSectionIds(correlationId, filter, paging);
	        });
	}

	ICommand makeGetSectionsCommand() {
		return new Command(
			"get_sections",
			new ObjectSchema(true)
				.withOptionalProperty('filter', new FilterParamsSchema())
				.withOptionalProperty('paging', new PagingParamsSchema()),
        (String correlationId, Parameters args)
	        {
	            var filter = FilterParams.fromValue(args.get('filter'));
	            var paging = PagingParams.fromValue(args.get('paging'));
	            return _controller.getSections(correlationId, filter, paging);
	        });
	}

	ICommand makeGetSectionByIdCommand() {
		return new Command(
			"get_section_by_id",
			new ObjectSchema(true)
				.withRequiredProperty('id', TypeCode.String),
            (String correlationId, Parameters args) {
                var id = args.getAsNullableString('id');
                return this._controller.getSectionById(correlationId, id);
            }
		);
	}

	ICommand makeSetSectionCommand() {
		return new Command(
			"set_section",
			new ObjectSchema(true)
				.withRequiredProperty('id', TypeCode.String)
				.withRequiredProperty('parameters', TypeCode.Map),
            (String correlationId, Parameters args) {
                var id = args.getAsNullableString('id');
                var parameters = ConfigParams.fromValue(args.getAsObject('parameters'));
                return this._controller.setSection(correlationId, id, parameters);
            }
		);
	}

	ICommand makeModifySectionCommand() {
		return new Command(
			"modify_section",
			new ObjectSchema(true)
				.withRequiredProperty('id', TypeCode.String)
				.withOptionalProperty('update_parameters', TypeCode.Map)
				.withOptionalProperty('increment_parameters', TypeCode.Map),
            (String correlationId, Parameters args) {
                var id = args.getAsNullableString('id');
                var updateParams = ConfigParams.fromValue(args.getAsObject('update_parameters'));
                var incrementParams = ConfigParams.fromValue(args.getAsObject('increment_parameters'));

                return this._controller.modifySection(correlationId, id, updateParams, incrementParams);
            }
		);
	}
}