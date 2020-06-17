import 'package:pip_services3_commons/pip_services3_commons.dart';

import 'ISettingsController.dart';

class SettingsCommandSet extends CommandSet {
  ISettingsController _controller;

  SettingsCommandSet(ISettingsController controller) : super() {
    _controller = controller;

    // Register commands to the database
    addCommand(makeGetSectionIdsCommand());
    addCommand(makeGetSectionsCommand());
    addCommand(makeGetSectionByIdCommand());
    addCommand(makeSetSectionCommand());
    addCommand(makeModifySectionCommand());
  }

  ICommand makeGetSectionIdsCommand() {
    return Command(
        'get_section_ids',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return _controller.getSectionIds(correlationId, filter, paging);
    });
  }

  ICommand makeGetSectionsCommand() {
    return Command(
        'get_sections',
        ObjectSchema(true)
            .withOptionalProperty('filter', FilterParamsSchema())
            .withOptionalProperty('paging', PagingParamsSchema()),
        (String correlationId, Parameters args) {
      var filter = FilterParams.fromValue(args.get('filter'));
      var paging = PagingParams.fromValue(args.get('paging'));
      return _controller.getSections(correlationId, filter, paging);
    });
  }

  ICommand makeGetSectionByIdCommand() {
    return Command('get_section_by_id',
        ObjectSchema(true).withRequiredProperty('id', TypeCode.String),
        (String correlationId, Parameters args) {
      var id = args.getAsNullableString('id');
      return _controller.getSectionById(correlationId, id);
    });
  }

  ICommand makeSetSectionCommand() {
    return Command(
        'set_section',
        ObjectSchema(true)
            .withRequiredProperty('id', TypeCode.String)
            .withRequiredProperty('parameters', TypeCode.Map),
        (String correlationId, Parameters args) {
      var id = args.getAsNullableString('id');
      var parameters = ConfigParams.fromValue(args.getAsObject('parameters'));
      return _controller.setSection(correlationId, id, parameters);
    });
  }

  ICommand makeModifySectionCommand() {
    return Command(
        'modify_section',
        ObjectSchema(true)
            .withRequiredProperty('id', TypeCode.String)
            .withOptionalProperty('update_parameters', TypeCode.Map)
            .withOptionalProperty('increment_parameters', TypeCode.Map),
        (String correlationId, Parameters args) {
      var id = args.getAsNullableString('id');
      var updateParams =
          ConfigParams.fromValue(args.getAsObject('update_parameters'));
      var incrementParams =
          ConfigParams.fromValue(args.getAsObject('increment_parameters'));

      return _controller.modifySection(
          correlationId, id, updateParams, incrementParams);
    });
  }
}
