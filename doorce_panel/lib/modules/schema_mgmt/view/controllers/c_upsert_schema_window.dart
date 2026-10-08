import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertSchemaWindow {
  final MUpsertSchemaWindow? _model;
  
  const CUpsertSchemaWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showSchemaManagementSelected(BuildContext context) {
    context.read<IUCShowSchemaManagement>().showSchemaManagementSelected(context);
  }

  showUpsertSchemaSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertSchema>().showUpsertSchemaSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertSchema>().upsertSchema(context, _model!.schema, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertSchema>().closeSelected(context);
  }

}
