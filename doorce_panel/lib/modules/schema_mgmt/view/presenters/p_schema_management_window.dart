import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/schema_management_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_schema_management_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPSchemaManagementWindow {
  show(BuildContext context, List<XDataSchema> datasetsResources,
      List<XSchemaSeries> seriesResources, List<XApp> apps, List<XAppTemplate> appTemplates, XUserAccount currentAccount);
  close(BuildContext context);
  void refreshResources(List<XIdentifiableElement> newResourceList);
  void refreshTemplateIsCompiled(String templateUri);
}

class PSchemaManagementWindow extends AbstractPresenter
    implements IPSchemaManagementWindow {
  final VSchemaManagementWindowFactory _vSchemaManagementWindowFactory;
  GlobalKey<VSchemaManagementWindowState>? _viewKey;
  late MSchemaManagementWindow _model;
  PSchemaManagementWindow(this._vSchemaManagementWindowFactory) : super(RoutingPrefixes.schemaManagement);

  @override
  show(BuildContext context, List<XDataSchema> datasetsResources,
      List<XSchemaSeries> seriesResources, List<XApp> apps, List<XAppTemplate> appTemplates, XUserAccount currentAccount) {
    _model = MSchemaManagementWindow(datasetsResources,seriesResources, apps, appTemplates, currentAccount);

    _viewKey = GlobalKey<VSchemaManagementWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}",
        false,
        _vSchemaManagementWindowFactory.get(_viewKey,_model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void refreshResources(List<XIdentifiableElement> newResourceList) {
    _model.refreshResourceList(newResourceList);
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshTemplateIsCompiled(String templateUri) {
    _model.refreshTemplateIsCompiled(templateUri);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    return super.getRoutingName();
  }
}
