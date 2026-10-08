import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_person_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_organization_details_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class COrganizationDetailsWindow {
  final MOrganizationDetailsWindow? _model;
  const COrganizationDetailsWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showPersonDetailsSelected(BuildContext context, String query) {
    context
        .read<IUCShowPersonDetails>()
        .showPersonDetailsSelected(context, query);
  }

  agentManagementSelected(BuildContext context) {
    context
        .read<IUCShowAgentManagement>()
        .showAgentManagementSelected(context, "");
  }
}
