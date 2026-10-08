import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/open_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_service_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPOpenServiceWindow {
  show(BuildContext context, List<XDistribution> servicesContentResources,
      String serviceIdentifier, String servicesTitle);
  close(BuildContext context);
}

class POpenServiceWindow extends AbstractPresenter
    implements IPOpenServiceWindow {
  final VOpenServiceWindowFactory _vServicesContentWindowFactory;
  late MOpenServiceWindow _model;
  POpenServiceWindow(this._vServicesContentWindowFactory) : super(RoutingPrefixes.openService);

  @override
  show(BuildContext context, List<XDistribution> servicesContentResources,
      String serviceIdentifier, String servicesTitle) {
    _model =
        MOpenServiceWindow(servicesContentResources, serviceIdentifier, servicesTitle);
    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
        false,
        _vServicesContentWindowFactory.get(_model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  String getRoutingName(){
    var identifier = _model.getServiceIdentifier();
    return "${super.getRoutingName()}:$identifier";
  }
}
