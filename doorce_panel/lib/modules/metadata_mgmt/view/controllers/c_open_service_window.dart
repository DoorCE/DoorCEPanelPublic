import 'package:doorce_panel/modules/data_mgmt/usecases/show_distribution_preview.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_service_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class COpenServiceWindow {
  final MOpenServiceWindow? _model;
  const COpenServiceWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context.read<IUCShowCatalogues>().showCataloguesSelected(context, identifier);
  }

  distributionContentSelected(BuildContext context, String identifier) {
    context.read<IUCShowDistributionPreview>().showDistributionContentSelected(context, identifier);
  }
}
