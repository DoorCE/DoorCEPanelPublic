import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/catalogues_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_catalogues_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPCataloguesWindow {
  show(
      BuildContext context,
      List<XOwnableResource> catalogsResources,
      List<XOwnableResource> datasetsResources,
      List<XOwnableResource> seriesResources,
      List<XOwnableResource> servicesResources,
      XCatalogue parentCatalogResources,
      List<XPerson> persons,
      List<XOrganization> organisations);
  close(BuildContext context);
  void refreshResources(List<XOwnableResource> newResourceList);
}

class PCataloguesWindow extends AbstractPresenter implements IPCataloguesWindow {
  final VCataloguesWindowFactory _vCataloguesWindowFactory;
  GlobalKey<VCataloguesWindowState>? _viewKey;
  late MCataloguesWindow _model;
  
  PCataloguesWindow(this._vCataloguesWindowFactory) : super(RoutingPrefixes.catalogues);

  @override
  show(
      BuildContext context,
      List<XOwnableResource> catalogsResources,
      List<XOwnableResource> datasetsResources,
      List<XOwnableResource> seriesResources,
      List<XOwnableResource> servicesResources,
      XCatalogue parentCatalogResources, List<XPerson> persons, List<XOrganization> organisations) {

    _model = MCataloguesWindow(
        catalogsResources,
        datasetsResources,
        seriesResources,
        servicesResources,
        parentCatalogResources,
        persons,
        organisations);

    _viewKey = GlobalKey<VCataloguesWindowState>();


    pushWindow(
        context,
        'images/catalogue.png',
        "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
        false,
        _vCataloguesWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void refreshResources(List<XOwnableResource> newResourceList) {
    _model.refreshResourceList(newResourceList);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.getParentCatalogIdentifier();
    return "${super.getRoutingName()}${null != identifier && identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
