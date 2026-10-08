import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCGenerateTemplate {
  Future<void> generateTemplateSelected(BuildContext context, XAppTemplate template);
}

class UCGenerateTemplate extends UCShowSchemaManagement implements IUCGenerateTemplate {
  
  UCGenerateTemplate(super.pSchemaManagementWindow, super.schemaManagement, super.appManagement, super.agentManagement);

  @override
  Future<void> generateTemplateSelected(BuildContext context, XAppTemplate template) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await appManagement.generateAppTemplate(template.identifier);
      int code = response.statusCode;

      if (200 == code) {
        pSchemaManagementWindow.refreshTemplateIsCompiled(template.identifier);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.templateGenerated);
      } else if (403 == code)
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      else
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.templateGenerateError);
      WaitMessage().dismiss();
    });
  }
}