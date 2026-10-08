import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CMainMenu {
  const CMainMenu();

  showCataloguesSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowCatalogues>()
        .showCataloguesSelected(context, identifier);
  }

  showDataManangementSelected(BuildContext context) {
    context.read<IUCShowDataManagement>().showDataManagementSelected(context);
  }

  showAgentManangementSelected(BuildContext context, String query) {
    context
        .read<IUCShowAgentManagement>()
        .showAgentManagementSelected(context, query);
  }

  showSchemaManangementSelected(BuildContext context) {
    context
        .read<IUCShowSchemaManagement>()
        .showSchemaManagementSelected(context);
  }
}
