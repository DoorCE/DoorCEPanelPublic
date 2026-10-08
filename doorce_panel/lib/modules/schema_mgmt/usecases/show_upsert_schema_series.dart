import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_schema_series_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertSchemaSeries {
  showUpsertSchemaSeriesSelected(BuildContext context, String? identifier, [bool? isPreview]);
  Future<void> upsertSchemaSeries(BuildContext context, XSchemaSeries series, bool isInsert);
  closeSelected(BuildContext context);
}

class UCShowUpsertSchemaSeries with ExceptionHandler implements IUCShowUpsertSchemaSeries {
  final IPUpsertSchemaSeriesWindow _pUpsertSchemaSeriesWindow;
  final SchemaAPI _schemaManagement;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertSchemaSeries(this._pUpsertSchemaSeriesWindow, this._schemaManagement, this._agentManagement);

  @override
  void showUpsertSchemaSeriesSelected(BuildContext context, String? identifier, [bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XDataSchema> schemaResources;
      XSchemaSeries series;
      List<XPerson> peopleResources = await _agentManagement.getPersons("");
      List<XOrganization> organizationResources = await _agentManagement.getOrganizations("");
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();

      if (identifier == null || identifier.isEmpty) {
        series = XSchemaSeries.forInsert();
        schemaResources = List<XDataSchema>.empty();
      } else {
        series = await _schemaManagement.getSchemaSeries(identifier);
        schemaResources = await _schemaManagement.getSeriesDataSchemaList(series.identifier);
      }
      WaitMessage().dismiss();

      _pUpsertSchemaSeriesWindow.show(context, series, schemaResources, peopleResources, organizationResources, currentUserAccount, currentAgent, isPreview);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertSchemaSeriesWindow.close(context);
  }

  @override
  Future<void> upsertSchemaSeries(BuildContext context, XSchemaSeries series, bool isInsert) async {
    if (isInsert && !await _schemaManagement.checkSchemaSeriesId(series.identifier)){
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
      return;
    }
    
    await tryForApiExceptions(context, () async {
      Response response = await _schemaManagement.upsertSchemaSeries(series);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.schemaSeriesUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.schemaSeriesError);}
      
      _pUpsertSchemaSeriesWindow.refreshIsInsert(code);
      _pUpsertSchemaSeriesWindow.refreshUserRoles(code);
    });
  }
}