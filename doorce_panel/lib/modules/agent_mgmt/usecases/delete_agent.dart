import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteAgent {
  void deleteAgentSelected(BuildContext context, XIdentifiableElement agent);
}

class UCDeleteAgent extends UCShowAgentManagement implements IUCDeleteAgent {
  
  UCDeleteAgent(super.pAgentManagementWindow, super.agentManagement);

  @override
  void deleteAgentSelected(BuildContext context, XIdentifiableElement agent) async {
    DialogResult response = await showDeleteDialog(context, agent.identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await agentManagement.deleteAgent(agent.identifier);
      int code = response.statusCode;

      if (200 == code) {
        if (agent is XPerson) {
          List<XPerson> people = await agentManagement.getPersons("");
          pAgentManagementWindow.refreshAgents(people);
        } else if (agent is XOrganization) {
          List<XOrganization> organizations = await agentManagement.getOrganizations("");
          pAgentManagementWindow.refreshAgents(organizations);
        }
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.agentDeleted);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.agentDeleteError);
      WaitMessage().dismiss();
    });
  }
}
