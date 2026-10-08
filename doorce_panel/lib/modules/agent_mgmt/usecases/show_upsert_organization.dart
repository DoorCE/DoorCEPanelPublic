import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_organization_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertOrganization {
  showUpsertOrganizationSelected(BuildContext context, String? identifier);
  Future<void>upsertOrganization(BuildContext context, XOrganization organization, List<XContactData> newContacts, bool isInsert);
  closeSelected(BuildContext context);
}

class UCShowUpsertOrganization with ExceptionHandler implements IUCShowUpsertOrganization {
  final IPUpsertOrganizationWindow _pUpsertOrganizationWindow;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertOrganization(this._pUpsertOrganizationWindow, this._agentManagement);

  @override
  showUpsertOrganizationSelected(BuildContext context, String? identifier) async {
    await tryForApiExceptions(context, () async {  
      WaitMessage().show(context);
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();
      XOrganization organization;
      List<XContactData> existingContactResources = [];
      List<XPerson> peopleResources = await _agentManagement.getPersons("");

      if(identifier == null || identifier.isEmpty) {
        organization = XOrganization.forInsert();
      } else {
        organization = await _agentManagement.getOrganization(identifier);
        existingContactResources =
          await _agentManagement.getContactData(identifier);
      }
      WaitMessage().dismiss();

      _pUpsertOrganizationWindow.show(context, organization, peopleResources, existingContactResources, currentUserAccount, currentAgent);
    });
  }
  
  @override
  closeSelected(BuildContext context) {
    _pUpsertOrganizationWindow.close(context);
  }
  
  @override
  Future<void>upsertOrganization(BuildContext context, XOrganization organization, List<XContactData> newContacts, bool isInsert) async {
    await tryForApiExceptions(context, () async {  
      if (isInsert && !await _agentManagement.checkAgentId(organization.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response response = await _agentManagement.upsertOrganization(organization, newContacts);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.agentUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.agentError);}
      
      _pUpsertOrganizationWindow.refreshIsInsert(code);
      _pUpsertOrganizationWindow.refreshUserRoles(code);
    });
  }
}