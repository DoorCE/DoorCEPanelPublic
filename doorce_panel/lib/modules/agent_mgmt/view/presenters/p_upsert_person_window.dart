import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_person_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_person_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertPersonWindow {
  show(BuildContext context, XPerson person,
      List<XOrganization> organizationsResources, List<XContactData> existingContacts, XUserAccount currentUserAccount);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult) {}

  void refreshAvailableAccountIds(List<String> accountIds) {}
}

class PUpsertPersonWindow extends AbstractPresenter
    implements IPUpsertPersonWindow {
  final VUpsertPersonWindowFactory _vUpsertPersonWindowFactory;
  GlobalKey<VUpsertPersonWindowState>? _viewKey;
  late MUpsertPersonWindow _model;
  PUpsertPersonWindow(this._vUpsertPersonWindowFactory) : super(RoutingPrefixes.upsertPerson) {
    _viewKey = GlobalKey<VUpsertPersonWindowState>();
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XPerson person, List<XOrganization> organizationsResources, List<XContactData> existingContacts, currentUserAccount) {
    _model = MUpsertPersonWindow(person, organizationsResources, existingContacts, currentUserAccount);

    _viewKey = GlobalKey<VUpsertPersonWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertPersonWindowFactory.get(_viewKey, _model));
  }
  // change "mode" to update if dataset was successfully inserted
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
    var identifier = _model.person.identifier;
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}