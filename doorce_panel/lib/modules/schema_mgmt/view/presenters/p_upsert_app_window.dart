import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_app_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_app_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertAppWindow {
  show(
      BuildContext context,
      XApp app,
      List<XAppTemplate> templates,
      List<XDataset> datasets,
      List<XAgent> agents,
      List<XCatalogue> catalogues,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      [bool? isPreview]
      );
  close(BuildContext context);
  void refreshIsInsert(int upsertResult);
  void refreshResources(List<XDataset> datasets);
  void refreshUserRoles(int statusCode);
}

class PUpsertAppWindow extends AbstractPresenter
    implements IPUpsertAppWindow {
  final VUpsertAppWindowFactory _vUpsertAppWindowFactory;
  GlobalKey<VUpsertAppWindowState>? _viewKey;
  late MUpsertAppWindow _model;
  PUpsertAppWindow(this._vUpsertAppWindowFactory) : super(RoutingPrefixes.upsertApp);

  @override
  show(BuildContext context, XApp app, List<XAppTemplate> templates, List<XDataset> datasets, List<XAgent> agents, 
    List<XCatalogue> catalogues, XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]) {
    _model = MUpsertAppWindow(app, templates, datasets, agents, catalogues, currentUserAccount, currentAgent, isPreview);

    _viewKey = GlobalKey<VUpsertAppWindowState>();

    pushWindow(
        context,
        'images/schema.png', // TODO change icon
        "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertAppWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  // change "mode" to update if dataset was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
  }

  // refresh available options for resource dropdown
  @override
  void refreshResources(List<XDataset> datasets) {
    _model.refreshDatasets(datasets);
    _viewKey!.currentState?.refresh();
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
    var identifier = _model.app.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewApp}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
