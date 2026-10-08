import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_series_content.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_data_management_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/publish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/unpublish_dataset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CDataManagementWindow {
  final MDataManagementWindow? _model;
  const CDataManagementWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  openDatasetContent(
      BuildContext context, String identifier) {
    context
        .read<IUCShowDatasetContent>()
        .showDatasetContentSelected(context, identifier);
  }

  openSeriesContent(BuildContext context, String identifier) {
    context.read<IUCShowSeriesContent>().showSeriesContentSelected(context, identifier);
  }

  publishDatasetSelected(BuildContext context, XDataset dataset) {
    bool canPublishData = _model!.canPublishData(dataset);
    context.read<IUCPublishDataset>().publishDatasetSelected(context, dataset.identifier, withData: canPublishData);
  }

  unpublishDatasetSelected(BuildContext context, XDataset dataset) {
    context.read<IUCUnpublishDataset>().unpublishDatasetSelected(context, dataset);
  }
}
