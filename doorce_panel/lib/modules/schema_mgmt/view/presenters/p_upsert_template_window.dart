import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/default_app_template.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_template_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_template_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertTemplateWindow {
  show(
      BuildContext context,
      XAppTemplate template,
      List<XAppTemplate> templates,
      List<XDataSchema> schemas,
      List<XAgent> agents,
      List<Language> languages,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      [bool? isPreview]
      );
  close(BuildContext context);
  void refreshIsInsert(int upsertResult);
  void refreshUserRoles(int statusCode);
  void refreshDefaultItems(XDefaultAppTemplate defaultTemplate);
}

class PUpsertTemplateWindow extends AbstractPresenter
    implements IPUpsertTemplateWindow {
  final VUpsertTemplateWindowFactory _vUpsertTemplateWindowFactory;
  GlobalKey<VUpsertTemplateWindowState>? _viewKey;
  late MUpsertTemplateWindow _model;
  PUpsertTemplateWindow(this._vUpsertTemplateWindowFactory) : super(RoutingPrefixes.upsertTemplate);

  @override
  show(BuildContext context, XAppTemplate template, List<XAppTemplate> templates, List<XDataSchema> schemas, List<XAgent> agents, 
    List<Language> languages, XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]) {
    _model = MUpsertTemplateWindow(template, templates, schemas, agents, languages, currentUserAccount, currentAgent, isPreview);

    _viewKey = GlobalKey<VUpsertTemplateWindowState>();

    pushWindow(
        context,
        'images/schema.png', // TODO change icon
        "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertTemplateWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
    _viewKey?.currentState?.refresh();
  }

  @override
  void refreshUserRoles(int statusCode) {
    if (200 == statusCode) {
      _model.refreshUserRoles();
      _viewKey!.currentState?.refresh();
    }
  }

  @override
  void refreshDefaultItems(XDefaultAppTemplate defaultTemplate) {
    _model.template.useCaseScenarios = defaultTemplate.useCaseScenarios;
    _model.template.auxiliaryConcepts = defaultTemplate.auxiliaryConcepts;
    _viewKey!.currentState?.refresh();
   }

  @override
  String getRoutingName(){
    var identifier = _model.template.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewTemplate}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}