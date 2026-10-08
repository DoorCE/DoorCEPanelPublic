import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/organization_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_organization_details_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPOrganizationDetailsWindow {
  show(
      BuildContext context,
      List<XPerson> peopleResources,
      XOrganization organizationResource,
      List<XContactData> contactDataResources);
  close(BuildContext context);
}

class POrganizationDetailsWindow extends AbstractPresenter
    implements IPOrganizationDetailsWindow {
  final VOrganizationDetailsWindowFactory _vOrganizationDetailsWindowFactory;
  late MOrganizationDetailsWindow _model;
  POrganizationDetailsWindow(this._vOrganizationDetailsWindowFactory) : super(RoutingPrefixes.previewOrganisation);

  @override
  show(
      BuildContext context,
      List<XPerson> peopleResources,
      XOrganization organizationResource,
      List<XContactData> contactDataResources) {
    _model = MOrganizationDetailsWindow(
        peopleResources, organizationResource, contactDataResources);

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
        false,
        _vOrganizationDetailsWindowFactory.get(_model));
  }

  @override
  String getRoutingName(){
    var identifier = _model.getOrganizationIdentifier();
    return "${super.getRoutingName()}:$identifier";
  }

  @override
  close(BuildContext context) {
    popWindow(context);
  }
}
