import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_person_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertPerson {
  showUpsertPersonSelected(BuildContext context, String? identifier);
  Future<void> upsertPerson(BuildContext context, XPerson person, List<XContactData> newContacts, bool isInsert);
  closeSelected(BuildContext context);

  Future<void> accountIdsSearchQueryChanged(String query) async {}
}

class UCShowUpsertPerson with ExceptionHandler implements IUCShowUpsertPerson {
  final IPUpsertPersonWindow _pUpsertPersonWindow;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertPerson(this._pUpsertPersonWindow, this._agentManagement);

  @override
  void showUpsertPersonSelected(BuildContext context, String? identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      List<XOrganization> organizationsResources = await _agentManagement.getAllowedOrganizations(identifier);
      List<XContactData> existingContactResources = [];
      XPerson person;

      if (null == identifier || identifier.isEmpty) {
        person = XPerson.forInsert();
      } else {
        person = await _agentManagement.getPerson(identifier);
        existingContactResources =
          await _agentManagement.getContactData(identifier);
      }
      WaitMessage().dismiss();

      _pUpsertPersonWindow.show(context, person, organizationsResources, existingContactResources, currentUserAccount);
    });
  }

  Future<void> accountIdsSearchQueryChanged(String query) async {
    // TODO - modify for tryForApiExceptions
    List<String> accountIds;
    if (3 > query.length) {
      accountIds = [];
    } else {
      accountIds = await _agentManagement.getAvailableAccountIds(query);
    }
    _pUpsertPersonWindow.refreshAvailableAccountIds(accountIds);
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertPersonWindow.close(context);
  }

  @override
  Future<void> upsertPerson(BuildContext context, XPerson person, List<XContactData> newContacts, bool isInsert) async {
    await tryForApiExceptions(context, () async {
      // TODO - check account id?
      if (isInsert && !await _agentManagement.checkAgentId(person.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response response = await _agentManagement.upsertPerson(person, newContacts);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.agentUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.agentError);}
      
      _pUpsertPersonWindow.refreshIsInsert(code);
    });
  }
}