import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_app_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertAppWindow {
  final MUpsertAppWindow? _model;
  
  const CUpsertAppWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showSchemaManagementSelected(BuildContext context) {
    context.read<IUCShowSchemaManagement>().showSchemaManagementSelected(context);
  }

  showUpsertAppSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertApp>().showUpsertAppSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertApp>().upsertApp(context, _model!.app, _model.newResources, _model.selectedCatalogueUri, _model.isInsert);
  }

  Future<void> schemaChanged(BuildContext context) async {
    final schemaUri = _model!.templates
        .firstWhere((template) => template.identifier == _model.app.templateUri)
        .schemaUri;
    
    await context.read<IUCShowUpsertApp>().schemaChanged(context, schemaUri);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertApp>().closeSelected(context);
  }
}