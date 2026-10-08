import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_series_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class COpenSeriesWindow {
  final MOpenSeriesWindow? _model;
  const COpenSeriesWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context.read<IUCShowCatalogues>().showCataloguesSelected(context, identifier);
  }

  upsertDatasetSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertDataset>().showUpsertDatasetSelected(context, identifier, _model!.getCatalogueId(), _model.getSeriesId());
  }
}