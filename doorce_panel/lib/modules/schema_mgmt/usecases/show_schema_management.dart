import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_schema_management_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/app_mgmt.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowSchemaManagement {
  showSchemaManagementSelected(BuildContext context);
  closeSelected(BuildContext context);
}

class UCShowSchemaManagement with ExceptionHandler implements IUCShowSchemaManagement {
  final IPSchemaManagementWindow pSchemaManagementWindow;
  final SchemaAPI schemaManagement;
  final AppManagementAPI appManagement;
  final AgentManagementAPI agentManagement;

  const UCShowSchemaManagement(
      this.pSchemaManagementWindow, this.schemaManagement, this.appManagement, this.agentManagement);

  @override
  showSchemaManagementSelected(BuildContext context) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XDataSchema> schemaResources =
          await schemaManagement.getDataSchemaList(null);
      List<XSchemaSeries> seriesResources =
          await schemaManagement.getSchemaSeriesList("");
      List<XApp> apps = await appManagement.getAppList();
      List<XAppTemplate> appTemplates = await appManagement.getAppTemplateList();
      XUserAccount currentAccount = await agentManagement.getCurrentUserAccount();

      WaitMessage().dismiss();
      
      pSchemaManagementWindow.show(context, schemaResources, seriesResources, apps, appTemplates, currentAccount);
    });
  }

  @override
  closeSelected(BuildContext context) {
    pSchemaManagementWindow.close(context);
  }
}
