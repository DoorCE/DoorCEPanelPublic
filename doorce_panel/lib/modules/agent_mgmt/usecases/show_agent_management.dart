import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_agent_management_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IUCShowAgentManagement {
  showAgentManagementSelected(BuildContext context, String query);
  Future<void> upsertUser(BuildContext context, XUserAccount user, List<XUserAccount> userAccounts, XUserAccount currentUser);
  closeSelected(BuildContext context);
}

class UCShowAgentManagement with ExceptionHandler implements IUCShowAgentManagement {
  final IPAgentManagementWindow pAgentManagementWindow;
  final AgentManagementAPI agentManagement;

  const UCShowAgentManagement(this.pAgentManagementWindow, this.agentManagement);

  @override
  showAgentManagementSelected(BuildContext context, String query, {initTab = 0}) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XAgent? currentAgent = await agentManagement.getCurrentAgent();
      XUserAccount currentUserAccount = await agentManagement.getCurrentUserAccount();
      List<XUserAccount> userAccounts = [];
      List<XPerson> personsForAccounts = [];
      if (currentUserAccount.roles.contains(GlobalRole.AgentAdmin)) {
        userAccounts = await agentManagement.getUserAccounts();
        personsForAccounts = await agentManagement.getAllowedPersonsForAccounts(null);
      }
      List<XPerson> peopleResources = await agentManagement.getPersons(query);
      List<XOrganization> organizationResources = await agentManagement.getOrganizations(query);
      WaitMessage().dismiss();

      pAgentManagementWindow.show(context, userAccounts, peopleResources, organizationResources, currentAgent, currentUserAccount, personsForAccounts);
    });
  }

  @override
  Future<void> upsertUser(BuildContext context, XUserAccount user, List<XUserAccount> userAccounts, XUserAccount currentUser) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await agentManagement.upsertUserAccount(user);
      int code = response.statusCode;

      if (code == 200) {
        if (user.userId == currentUser.userId && !user.roles.contains(GlobalRole.AgentAdmin)) {
          await showAgentManagementSelected(context, "");
        } else {
          List<XPerson> personsForAccounts = await agentManagement.getAllowedPersonsForAccounts(null);
          pAgentManagementWindow.refreshPersonsForAccounts(personsForAccounts);
        }
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.userUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.userError);}
      WaitMessage().dismiss();
    });
  }

  @override
  void closeSelected(BuildContext context) {
    pAgentManagementWindow.close(context);
  }
}
