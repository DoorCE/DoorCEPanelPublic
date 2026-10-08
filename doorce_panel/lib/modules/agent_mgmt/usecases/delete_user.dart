import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteUser {
  void deleteUserSelected(BuildContext context, XUserAccount user);
}

class UCDeleteUser extends UCShowAgentManagement implements IUCDeleteUser {
  
  UCDeleteUser(super.pAgentManagementWindow, super.agentManagement);

  @override
  void deleteUserSelected(BuildContext context, XUserAccount user) async {
    DialogResult response = await showDeleteDialog(context, user.userId);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await agentManagement.deleteUserAccount(user.userId);
      int code = response.statusCode;

      if (200 == code) {
        List<XUserAccount> users = await agentManagement.getUserAccounts();
        pAgentManagementWindow.refreshUsers(users);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.userDeleted);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.userDeleteError);
      WaitMessage().dismiss();
    });
  }
}