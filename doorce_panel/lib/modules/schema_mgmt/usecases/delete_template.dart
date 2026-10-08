import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteAppTemplate {
  void deleteAppTemplateSelected(BuildContext context, XAppTemplate template);
}

class UCDeleteAppTemplate extends UCShowSchemaManagement implements IUCDeleteAppTemplate {
  
  UCDeleteAppTemplate(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  void deleteAppTemplateSelected(BuildContext context, XAppTemplate template) async {
    DialogResult response = await showDeleteDialog(context, template.identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await appManagement.deleteAppTemplate(template.identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XAppTemplate> templates = await appManagement.getAppTemplateList();
        pSchemaManagementWindow.refreshResources(templates);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.templateDeleted);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.templateDeleteError);
      WaitMessage().dismiss();
    });
  }
}