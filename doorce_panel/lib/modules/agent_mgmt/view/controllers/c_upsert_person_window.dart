import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_person_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertPersonWindow {
  final MUpsertPersonWindow? _model;
  
  const CUpsertPersonWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  agentManagementSelected(BuildContext context) {
    context.read<IUCShowAgentManagement>().showAgentManagementSelected(context, "");
  }

  Future<void> saveSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCShowUpsertPerson>().upsertPerson(context, _model.person, _model.newContacts, _model.isInsert);
  }

  Future<void> accountIdsSearchQueryChanged(BuildContext context, String query) async {
    await context.read<IUCShowUpsertPerson>().accountIdsSearchQueryChanged(query);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertPerson>().closeSelected(context);
  }
}
