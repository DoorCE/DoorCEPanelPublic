import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_organization_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_person_details_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CPersonDetailsWindow {
  final MPersonDetailsWindow? _model;
  const CPersonDetailsWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showOrganizationDetailsSelected(BuildContext context, String query) {
    context
        .read<IUCShowOrganizationDetails>()
        .showOrganizationDetailsSelected(context, query);
  }

  agentManagementSelected(BuildContext context) {
    context
        .read<IUCShowAgentManagement>()
        .showAgentManagementSelected(context, "");
  }
}
