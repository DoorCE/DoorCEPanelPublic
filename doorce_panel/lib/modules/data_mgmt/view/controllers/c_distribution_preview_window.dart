import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_distribution_preview_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_open_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CDistributionPreviewWindow {
  final MDistributionPreviewWindow? _model;
  const CDistributionPreviewWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  dataManagementSelected(BuildContext context) {
    context.read<IUCShowDataManagement>().showDataManagementSelected(context);
  }

  openDatasetContent(BuildContext context) {
    context
        .read<IUCShowDatasetContent>()
        .showDatasetContentSelected(context, _model!.getDatasetIdentifier());
  }

  openServiceContent(BuildContext context) {
    context.read<IUCShowOpenService>().showServicesContentSelected(context, _model!.getServiceIdentifier());
  }
}