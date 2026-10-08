import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_series_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertSeriesWindow {
  final MUpsertSeriesWindow? _model;

  const CUpsertSeriesWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowCatalogues>()
        .showCataloguesSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCShowUpsertSeries>()
      .upsertSeries(context, _model.series, _model.newContacts, _model.isInsert);
  }

  void pickIconSelected(BuildContext context) {
    context.read<IUCShowUpsertSeries>().pickIconSelected(context);
  }

  Future<void> contactSourcesChanged(BuildContext context) async {
    final agentIds = <String>{}; 
    XDatasetSeries series = _model!.series; 

    if (series.responsiblePersonID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }
    if (series.responsibleOrganisationID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }

    final editors = series.editorIDList;
      if (editors.isNotEmpty) {
        agentIds.addAll(editors);
      }

    await context.read<IUCShowUpsertSeries>().contactSourcesChanged(agentIds.toList());
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertSeries>().closeSelected(context);
  }
}
