import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_series_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertSchemaSeriesWindow {
  final MUpsertSchemaSeriesWindow? _model;
  
  const CUpsertSchemaSeriesWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showSchemaManagementSelected(BuildContext context) {
    context.read<IUCShowSchemaManagement>().showSchemaManagementSelected(context);
  }

  showUpsertSchemaSeriesSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertSchemaSeries>().showUpsertSchemaSeriesSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertSchemaSeries>().upsertSchemaSeries(context, _model!.series, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertSchemaSeries>().closeSelected(context);
  }

}
