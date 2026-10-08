import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_upsert_distribution.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_upsert_distribution_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertDistributionWindow {
  final MUpsertDistributionWindow? _model;
  
  const CUpsertDistributionWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  dataManagementSelected(BuildContext context) {
    context.read<IUCShowDataManagement>().showDataManagementSelected(context);
  }

  openDatasetContent(BuildContext context, String identifier) {
    context
        .read<IUCShowDatasetContent>()
        .showDatasetContentSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    await context
        .read<IUCShowUpsertDistribution>()
        .upsertDistribution(context, _model!.distribution, _model.fileData, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    await context.read<IUCShowUpsertDistribution>().closeSelected(context);
  }
}
