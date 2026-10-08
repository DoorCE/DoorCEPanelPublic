import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/delete_agent.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/delete_user.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_organization_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_person_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_organization.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_person.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_user.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_agent_management_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CAgentManagementWindow {
  final MAgentManagementWindow? _model;
  
  const CAgentManagementWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  upsertPersonSelected(BuildContext context, String? identifier) {
    context.read<IUCShowUpsertPerson>().showUpsertPersonSelected(context, identifier);
  }

  upsertOrganizationSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertOrganization>().showUpsertOrganizationSelected(context, identifier);
  }

  showUpsertUserSelected(BuildContext context, String? identifier) {
    context.read<IUCShowUpsertUser>().showUpsertUserSelected(context, identifier);
  }

  saveUserSelected(BuildContext context, XUserAccount user) async {
    await context.read<IUCShowAgentManagement>().upsertUser(context, user, _model!.userAccounts, _model.currentUserAccount);
  }

  openOrganizationDetails(BuildContext context, String identifier) {
    context.read<IUCShowOrganizationDetails>().showOrganizationDetailsSelected(context, identifier);
  }

  openPersonDetails(BuildContext context, String identifier) {
    context.read<IUCShowPersonDetails>().showPersonDetailsSelected(context, identifier);
  }

  deleteAgentSelected(BuildContext context, XIdentifiableElement agent) {
    context.read<IUCDeleteAgent>().deleteAgentSelected(context, agent);
  }

  deleteUserSelected(BuildContext context, XUserAccount user) {
    context.read<IUCDeleteUser>().deleteUserSelected(context, user);
  }
}
