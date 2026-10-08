import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_organization_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_organization_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

abstract interface class IPUpsertOrganizationWindow {
  show(BuildContext context, XOrganization organization,
      List<XPerson> peopleResources, List<XContactData> existingContacts,
      XUserAccount currentUserAccount, XAgent? currentAgent);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult) {}
  void refreshUserRoles(int statusCode) {}
}

class PUpsertOrganizationWindow extends AbstractPresenter
    implements IPUpsertOrganizationWindow {
  final VUpsertOrganizationWindowFactory _vUpsertOrganizationWindowFactory;
  GlobalKey<VUpsertOrganizationWindowState>? _viewKey;
  late MUpsertOrganizationWindow _model;
  PUpsertOrganizationWindow(this._vUpsertOrganizationWindowFactory) : super(RoutingPrefixes.upsertOrganisation) {
    _viewKey = GlobalKey<VUpsertOrganizationWindowState>();
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XOrganization organization, 
    List<XPerson> peopleResources, List<XContactData> existingContacts,
    XUserAccount currentUserAccount, XAgent? currentAgent) {
    _model = MUpsertOrganizationWindow(organization, peopleResources, existingContacts, currentUserAccount, currentAgent);

    _viewKey = GlobalKey<VUpsertOrganizationWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertOrganizationWindowFactory.get(_viewKey, _model));
  }

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
    var identifier = _model.organization.identifier;
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
