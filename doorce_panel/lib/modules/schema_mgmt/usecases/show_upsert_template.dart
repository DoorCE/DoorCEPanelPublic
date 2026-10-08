import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/default_app_template.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_template_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/app_mgmt.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertTemplate {
  showUpsertTemplateSelected(BuildContext context, String? identifier, [bool? isPreview]);
  Future<void> upsertTemplate(BuildContext context, XAppTemplate template, bool isInsert);
  closeSelected(BuildContext context);
  Future<void> getDefaultAppTemplate(BuildContext context, String schemaId, String? conceptName);
}

class UCShowUpsertTemplate with ExceptionHandler implements IUCShowUpsertTemplate {
  final IPUpsertTemplateWindow _pUpsertTemplateWindow;
  final AppManagementAPI _appManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final SchemaAPI _schemaManagement;
  final AgentManagementAPI _agentManagement;

  const UCShowUpsertTemplate(this._pUpsertTemplateWindow, this._appManagement, this._vocabularyManagement, this._schemaManagement, this._agentManagement);

  @override
  void showUpsertTemplateSelected(BuildContext context, String? identifier, [bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XAppTemplate> templates = await _appManagement.getAppTemplateList();
      List<XDataSchema> schemas = await _schemaManagement.getDataSchemaList(null);

      String locale = Localizations.localeOf(context).languageCode;
      List<Language> languages = await _vocabularyManagement.getLanguages(locale);

      List<XPerson> persons = await _agentManagement.getPersons("");
      List<XOrganization> organizations = await _agentManagement.getOrganizations("");
      List<XAgent> agents = [...persons, ...organizations];

      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();

      XAppTemplate template;

      if (identifier == null || identifier.isEmpty) {
        template = XAppTemplate.forInsert();
      } else {
        template = await _appManagement.getAppTemplate(identifier);
      }
      WaitMessage().dismiss();

      _pUpsertTemplateWindow.show(context, template, templates, schemas, agents, languages, currentUserAccount, currentAgent, isPreview);
    });
  }

  @override
  Future<void> getDefaultAppTemplate(BuildContext context, String schemaId, String? conceptName) async {
    XDefaultAppTemplate defaultTemplate = XDefaultAppTemplate();
    if (schemaId.isNotEmpty) {
      await tryForApiExceptions(context, () async {
        defaultTemplate = await _appManagement.getDefaultAppTemplate(schemaId, conceptName);
      });
    }
    _pUpsertTemplateWindow.refreshDefaultItems(defaultTemplate);
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertTemplateWindow.close(context);
  }

  @override
  Future<void> upsertTemplate(BuildContext context, XAppTemplate template, bool isInsert) async {
    if (isInsert && !await _appManagement.checkAppTemplateId(template.identifier)){
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
      return;
    }
    await tryForApiExceptions(context, () async {
      Response response = await _appManagement.upsertAppTemplate(template);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.templateCreated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else if (code == 400) {
        SnackMessage().show(context, true, text: response.body);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.templateError);}

      _pUpsertTemplateWindow.refreshIsInsert(code);
      _pUpsertTemplateWindow.refreshUserRoles(code);
    });
  }
}