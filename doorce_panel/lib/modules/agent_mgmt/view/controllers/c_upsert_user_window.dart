import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_user.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_user_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertUserWindow {
  final MUpsertUserWindow? _model;
  
  const CUpsertUserWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  agentManagementSelected(BuildContext context) {
    context.read<IUCShowAgentManagement>().showAgentManagementSelected(context, "");
  }

  Future<void> saveSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertUser>().upsertUser(context, _model!.user, _model.isInsert);
  }

  Future<void> accountIdsSearchQueryChanged(BuildContext context, String query) async {
    await context.read<IUCShowUpsertUser>().accountIdsSearchQueryChanged(query);
  }

  Future<void> cancelSelected(BuildContext context) async {
    await context.read<IUCShowUpsertUser>().closeSelected(context);
  }
}