import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_organization.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_organization_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertOrganizationWindow {
  final MUpsertOrganizationWindow? _model;
  
  const CUpsertOrganizationWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  upsertPersonSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowUpsertPerson>()
        .showUpsertPersonSelected(context, identifier);
  }

  agentManagementSelected(BuildContext context) {
    context
        .read<IUCShowAgentManagement>()
        .showAgentManagementSelected(context, "");
  }

  Future<void> saveSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context
        .read<IUCShowUpsertOrganization>()
        .upsertOrganization(context, _model.organization, _model.newContacts, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context
        .read<IUCShowUpsertOrganization>()
        .closeSelected(context);
  }
}
