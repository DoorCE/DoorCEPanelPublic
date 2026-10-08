import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_user_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_user_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertUserWindow {
  show(BuildContext context, XUserAccount user, List<XPerson> allowedPersons);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult) {}

  void refreshAvailableAccountIds(List<String> accountIds);
}

class PUpsertUserWindow extends AbstractPresenter
    implements IPUpsertUserWindow {
  final VUpsertUserWindowFactory _vUpsertUserWindowFactory;
  GlobalKey<VUpsertUserWindowState>? _viewKey;
  late MUpsertUserWindow _model;
  PUpsertUserWindow(this._vUpsertUserWindowFactory) : super(RoutingPrefixes.upsertUser) {
    _viewKey = GlobalKey<VUpsertUserWindowState>();
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XUserAccount user, List<XPerson> allowedPersons) {
    _model = MUpsertUserWindow(user, allowedPersons);

    _viewKey = GlobalKey<VUpsertUserWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertUserWindowFactory.get(_viewKey, _model));
  }
  // change "mode" to update if user was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
  }

  @override
  void refreshAvailableAccountIds(List<String> accountIds) {
    _model.refreshAvailableAccountIds(accountIds);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.user.userId;
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}