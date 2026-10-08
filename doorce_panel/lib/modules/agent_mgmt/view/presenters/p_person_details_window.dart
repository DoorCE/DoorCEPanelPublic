import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/person_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_person_details_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

abstract interface class IPPersonDetailsWindow {
  show(BuildContext context, XPerson personResource,
      List<XContactData> contactDataResources);
  close(BuildContext context);
}

class PPersonDetailsWindow extends AbstractPresenter
    implements IPPersonDetailsWindow {
  final VPersonDetailsWindowFactory _vPersonDetailsWindowFactory;
  late MPersonDetailsWindow _model;
  PPersonDetailsWindow(this._vPersonDetailsWindowFactory) : super(RoutingPrefixes.previewPerson);

  @override
  close(BuildContext context) {
    popWindow(context);
  }

  @override
  show(BuildContext context, XPerson personResource,
      List<XContactData> contactDataResources) {
    _model =
        MPersonDetailsWindow(personResource, contactDataResources);

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}",
        false,
        _vPersonDetailsWindowFactory.get(_model));
  }

  @override
  String getRoutingName(){
    var identifier = _model.getPersonIdentifier();
    return "${super.getRoutingName()}:$identifier";
  }
}
