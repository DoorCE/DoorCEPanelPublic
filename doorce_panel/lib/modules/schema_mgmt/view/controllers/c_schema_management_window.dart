import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_schema.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/deploy_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/generate_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/refresh_app_statuses.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/update_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_schema_management_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CSchemaManagementWindow {
  final MSchemaManagementWindow _model;
  CSchemaManagementWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  upsertSchemaSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertSchema>().showUpsertSchemaSelected(context, identifier);
  }

  upsertSchemaSeriesSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertSchemaSeries>().showUpsertSchemaSeriesSelected(context, identifier);
  }

  deleteSchemaSeriesSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteSchemaSeries>().deleteSchemaSeriesSelected(context, identifier);
  }

  deleteDataSchemaSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteSchema>().deleteDataSchemaSelected(context, identifier);
  }

  openDatasetContent(
      BuildContext context, String identifier) {
    context
        .read<IUCShowDatasetContent>()
        .showDatasetContentSelected(context, identifier);
  }

  upsertAppSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertApp>().showUpsertAppSelected(context, identifier);
  }

  updateAppFlagsSelected(BuildContext context, String identifier, bool isEnabled, bool isVisible) async {
    context.read<IUCUpdateApp>().updateAppFlagsSelected(context, identifier, isEnabled, isVisible);
  }

  deleteAppSelected(BuildContext context, XApp app) {
    context.read<IUCDeleteApp>().deleteAppSelected(context, app);
  }

  upsertTemplateSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertTemplate>().showUpsertTemplateSelected(context, identifier);
  }

  deleteTemplateSelected(BuildContext context, XAppTemplate template) {
    context.read<IUCDeleteAppTemplate>().deleteAppTemplateSelected(context, template);
  }

  generateAppTemplateSelected(BuildContext context, XAppTemplate template) async {
    await context.read<IUCGenerateTemplate>().generateTemplateSelected(context, template);
  }

  deployAppSelected(BuildContext context, XApp app) async {
    await context.read<IUCDeployApp>().deployAppSelected(context, app);
  }

  refreshAppStatuses(BuildContext context) async {
    await context.read<IUCRefreshAppStatuses>().refreshApps(context);
  }

  previewSchemaSelected(BuildContext context, String identifier) async {
    await context.read<IUCShowUpsertSchema>().showUpsertSchemaSelected(context, identifier, true);
  }

  previewSchemaSeriesSelected(BuildContext context, String identifier) async {
    await context.read<IUCShowUpsertSchemaSeries>().showUpsertSchemaSeriesSelected(context, identifier, true);
  }

  previewAppSelected(BuildContext context, String identifier) async {
    await context.read<IUCShowUpsertApp>().showUpsertAppSelected(context, identifier, true);
  }

  previewTemplateSelected(BuildContext context, String identifier) async {
    await context.read<IUCShowUpsertTemplate>().showUpsertTemplateSelected(context, identifier, true);
  }
}
