import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';

class CDoorDrawer {
  const CDoorDrawer();

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  catalogueSelected(BuildContext context) {
    context.read<IUCShowCatalogues>().showCataloguesSelected(context, "");
  }
}
