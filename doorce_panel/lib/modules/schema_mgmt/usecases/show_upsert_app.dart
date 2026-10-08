import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/source_creation_request.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_app_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/app_mgmt.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertApp {
  showUpsertAppSelected(BuildContext context, String? identifier, [bool? isPreview]);
  Future<void> upsertApp(BuildContext context, XApp app, List<XSourceCreationRequest> newResources, String? selectedCatalogueUri, bool isInsert);
  closeSelected(BuildContext context);
  Future<void> schemaChanged(BuildContext context, String schemaUri);
}

class UCShowUpsertApp with ExceptionHandler implements IUCShowUpsertApp {
  final IPUpsertAppWindow _pUpsertAppWindow;
  final AppManagementAPI _appManagement;
  final DatasetManagementAPI _datasetManagement;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertApp(this._pUpsertAppWindow, this._appManagement, this._datasetManagement, this._agentManagement);

  @override
  void showUpsertAppSelected(BuildContext context, String? identifier, [bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XAppTemplate> templates = await _appManagement.getAppTemplateList();
      List<XDataset> datasets;
      List<XPerson> persons = await _agentManagement.getPersons("");
      List<XOrganization> organizations = await _agentManagement.getOrganizations("");
      List<XAgent> agents = [...persons, ...organizations];
      List<XCatalogue> catalogues = await _datasetManagement.getAllowedCatalogues("");
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();

      XApp app;

      if (identifier == null || identifier.isEmpty) {
        app = XApp.forInsert();
        datasets = await _datasetManagement.getSchemaDatasets(null);
      } else {
        app = await _appManagement.getApp(identifier);
        var schemaUri = templates.firstWhere(
          (template) => template.identifier == app.templateUri
          ).schemaUri;
        datasets = await _datasetManagement.getSchemaDatasets(schemaUri);
      }
      WaitMessage().dismiss();

      _pUpsertAppWindow.show(context, app, templates, datasets, agents, catalogues, currentUserAccount, currentAgent, isPreview);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertAppWindow.close(context);
  }

  @override
  Future<void> schemaChanged(BuildContext context, String schemaUri) async {
    await tryForApiExceptions(context, () async {
      List<XDataset> datasets = await _datasetManagement.getSchemaDatasets(schemaUri);
      _pUpsertAppWindow.refreshResources(datasets);
    });
  }

  @override
  Future<void> upsertApp(BuildContext context, XApp app, List<XSourceCreationRequest> newResources, String? selectedCatalogueUri, bool isInsert) async {
    if (isInsert && !await _appManagement.checkAppId(app.identifier)){
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
      return;
    }
    await tryForApiExceptions(context, () async {
      Response response = await _appManagement.upsertApp(app, newResources, selectedCatalogueUri);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.appUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else if (code == 400) {
        SnackMessage().show(context, true, text: response.body);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.appError);}

      _pUpsertAppWindow.refreshIsInsert(code);
      _pUpsertAppWindow.refreshUserRoles(code);
    });
  }
}