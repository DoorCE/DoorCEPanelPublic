import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_user_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertUser {
  showUpsertUserSelected(BuildContext context, String? identifier);
  Future<void> upsertUser(BuildContext context, XUserAccount user, bool isInsert);
  closeSelected(BuildContext context);

  Future<void> accountIdsSearchQueryChanged(String query) async {}
}

class UCShowUpsertUser with ExceptionHandler implements IUCShowUpsertUser {
  final IPUpsertUserWindow _pUpsertUserWindow;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertUser(this._pUpsertUserWindow, this._agentManagement);

  @override
  void showUpsertUserSelected(BuildContext context, String? identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XUserAccount user;
      List<XPerson> allowedPersons;

      //if (null == identifier || identifier.isEmpty) {
        user = XUserAccount();
        allowedPersons = await _agentManagement.getAllowedPersonsForAccounts(null);
      //} else {
        //TODO - if needed
      //}
      WaitMessage().dismiss();

      _pUpsertUserWindow.show(context, user, allowedPersons);
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
    _pUpsertUserWindow.refreshAvailableAccountIds(accountIds);
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertUserWindow.close(context);
  }

  @override
  Future<void> upsertUser(BuildContext context, XUserAccount user, bool isInsert) async {
    await tryForApiExceptions(context, () async {
      Response response = await _agentManagement.upsertUserAccount(user);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.userUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.userError);}
      
      if (isInsert)
        _pUpsertUserWindow.refreshIsInsert(code);
    });
  }
}