import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/delete_data.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/delete_distribution.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_distribution_preview.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_upsert_distribution.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/upload_data.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/view_app.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_dataset_content_widow.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class CDatasetContentWindow {
  final MDatasetContentWindow? _model;
  const CDatasetContentWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  distributionContentSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowDistributionPreview>()
        .showDistributionContentSelected(context, identifier, false);
  }

  dataManagementSelected(BuildContext context) {
    context.read<IUCShowDataManagement>().showDataManagementSelected(context);
  }

  upsertDistributionSelected(BuildContext context, String? identifier) {
    context.read<IUCShowUpsertDistribution>().showUpsertDistributionSelected(
        context, _model!.dataset.identifier, identifier);
  }

  loadData(BuildContext context) async {
    return await context.read<IUCUploadData>().uploadDataSelected(
      context, _model!.concepts, _model.dataset.identifier, _model.fileData!);
  }

  clearData(BuildContext context) async {
    return await context.read<IUCDeleteData>().clearData(context, _model!.dataset.identifier);
  }

  deleteDistributionSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteDistribution>().deleteDistributionSelected(context, identifier, _model!.dataset.identifier);
  }

  viewDefaultApp(BuildContext context) async {
    XApp? app = _model!.defaultApp;
    if (!_model.isDefaultAppEnabled()) {
      final apps = _model.getViewableDatasetApps();

      if (apps.length != 1)
        throw Exception("Default app not found");

      app = _model.getViewableDatasetApps().first;
    }

    Logger.root.info("[CDatasetContentWindow viewDefaultApp] starting UCViewApp for app: ${app!.identifier} (dataset: ${_model.dataset.identifier})");

    await context.read<IUCViewApp>().viewDefaultApp(context, app, _model.dataset.identifier);
  }

  viewAppSelected(BuildContext context) async {
    final apps = _model!.getViewableDatasetApps();

    if (apps.isEmpty) {
      throw Exception("No viewable apps found");
    }

    Logger.root.info("[CDatasetContentWindow viewAppSelected] starting UCViewApp for multiple apps (dataset: ${_model.dataset.identifier})");

    await context.read<IUCViewApp>().viewAppSelected(context, apps, _model.dataset.identifier);
  }
}
