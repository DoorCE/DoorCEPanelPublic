import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_schema_series_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_series_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertSchemaSeriesWindow {
  show(
      BuildContext context,
      XSchemaSeries series,
      List<XDataSchema> schemaResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      [bool? isPreview]);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult) {}
  void refreshUserRoles(int statusCode) {}
}

class PUpsertSchemaSeriesWindow extends AbstractPresenter
    implements IPUpsertSchemaSeriesWindow {
  final VUpsertSchemaSeriesWindowFactory _vUpsertSchemaSeriesWindowFactory;
  GlobalKey<VUpsertSchemaSeriesWindowState>? _viewKey;
  late MUpsertSchemaSeriesWindow _model;
  PUpsertSchemaSeriesWindow(this._vUpsertSchemaSeriesWindowFactory) : super(RoutingPrefixes.upsertSchemaSeries);

  @override
  show(BuildContext context, XSchemaSeries series, List<XDataSchema> schemaResources, 
    List<XPerson> peopleResources, List<XOrganization> organizationResources, XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]) {
    _model = MUpsertSchemaSeriesWindow(series, schemaResources, 
        peopleResources, organizationResources, currentUserAccount, currentAgent, isPreview);

    _viewKey = GlobalKey<VUpsertSchemaSeriesWindowState>();

    pushWindow(
        context,
        'images/schema_series.png',
        "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertSchemaSeriesWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  // change "mode" to update if dataset was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
  }

  @override
  void refreshUserRoles(int statusCode) {
    if (200 == statusCode) {
      _model.refreshUserRoles();
      _viewKey!.currentState?.refresh();
    }
  }

  @override
  String getRoutingName(){
    var identifier = _model.series.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewSchemaSeries}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}