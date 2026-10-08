import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_template_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertTemplateWindow {
  final MUpsertTemplateWindow? _model;
  
  const CUpsertTemplateWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showSchemaManagementSelected(BuildContext context) {
    context.read<IUCShowSchemaManagement>().showSchemaManagementSelected(context);
  }

  showUpsertTemplateSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertTemplate>().showUpsertTemplateSelected(context, identifier);
  }

  refreshDefaultItems(BuildContext context) async {
    await context.read<IUCShowUpsertTemplate>().getDefaultAppTemplate(context, _model!.template.schemaUri, _model.conceptNameForDefaultScenarios);
  }

  Future<void> saveSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertTemplate>().upsertTemplate(context, _model!.template, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertTemplate>().closeSelected(context);
  }
}