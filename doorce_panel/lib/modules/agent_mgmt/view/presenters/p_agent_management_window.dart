import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/agent_management_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_agent_management_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPAgentManagementWindow {
  show(BuildContext context, List<XUserAccount> userAccounts, List<XPerson> peopleResources,
      List<XOrganization> organizationResources, XAgent? currentAgent, XUserAccount currentUserAccount, List<XPerson> personsForAccounts);
  close(BuildContext context);
  void refreshAgents(List<XIdentifiableElement> newResourceList);
  void refreshUsers(List<XUserAccount> newUserList);

  void refreshPersonsForAccounts(List<XPerson> personsForAccounts) {}

  void refreshCurrentUserAccount(XUserAccount user) {}
}

class PAgentManagementWindow extends AbstractPresenter
    implements IPAgentManagementWindow {
  final VAgentManagementWindowFactory _vAgentManagementWindowFactory;
  GlobalKey<VAgentManagementWindowState>? _viewKey;
  late MAgentManagementWindow _model;
  PAgentManagementWindow(this._vAgentManagementWindowFactory) : super(RoutingPrefixes.agentManagement);

  @override
  show(BuildContext context, List<XUserAccount> userAccounts, List<XPerson> peopleResources, List<XOrganization> organizationResources,
    XAgent? currentAgent, XUserAccount currentUserAccount, List<XPerson> personsForAccounts) {
    _model = MAgentManagementWindow(userAccounts, peopleResources, organizationResources, currentAgent, currentUserAccount, personsForAccounts);

    _viewKey = GlobalKey<VAgentManagementWindowState>();

    pushWindow(
      context,
      "",
      "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
      false,
      _vAgentManagementWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) {
    popWindow(context);
  }

  @override
  String getRoutingName(){
    return super.getRoutingName();
  }

  @override
  void refreshAgents(List<XIdentifiableElement> newAgentList) {
    _model.refreshAgentList(newAgentList);
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshUsers(List<XUserAccount> newUserList) {
    _model.refreshUserAccountList(newUserList);
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshPersonsForAccounts(List<XPerson> personsForAccounts) {
    _model.refreshPersonsForAccounts(personsForAccounts);
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshCurrentUserAccount(XUserAccount user) {
    _model.refreshCurrentUserAccount(user);
    _viewKey!.currentState?.resetSelectedOption();
    _viewKey!.currentState?.refresh();
  }
}