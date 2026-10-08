import 'package:doorce_panel/modules/data_mgmt/usecases/delete_dataset_from_series.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_series_content_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CSeriesContentWindow {
  final MSeriesContentWindow? _model;
  const CSeriesContentWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  datasetContentSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowDatasetContent>()
        .showDatasetContentSelected(context, identifier);
  }

  dataManagementSelected(BuildContext context) {
    context.read<IUCShowDataManagement>().showDataManagementSelected(context);
  }

  upsertDatasetSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertDataset>().showUpsertDatasetSelected(
        context, identifier, _model!.series.catalogueID, _model.series.identifier);
  }

  deleteDatasetSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteDatasetFromSeries>().deleteDatasetSelected(context, identifier, _model!.getSeriesIdentifier());
  }
}
