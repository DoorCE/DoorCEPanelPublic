import 'dart:typed_data';

import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_catalogue_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_catalogue_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertCatalogueWindow {
  show(
      BuildContext context,
      XCatalogue catalogue,
      List<Language> languageResources,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<XContactData> existingContactResources,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      [bool? isPreview]);
  close(BuildContext context);

  void refreshContactResources(List<XContactData> agentContacts) {}
  void refreshIsInsert(int upsertResult) {}
  void refreshUserRoles(int statusCode) {}
  void refreshIcon(String iconUri, Uint8List iconFile) {}
}

class PUpsertCatalogueWindow extends AbstractPresenter
    implements IPUpsertCatalogueWindow {
  final VUpsertCatalogueWindowFactory _vUpsertCatalogueWindowFactory;
  GlobalKey<VUpsertCatalogueWindowState>? _viewKey;
  late MUpsertCatalogueWindow _model;
  PUpsertCatalogueWindow(this._vUpsertCatalogueWindowFactory) : super(RoutingPrefixes.upsertCatalogue);

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XCatalogue catalogue, List<Language> languageResources, List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources, List<XOrganization> organizationResources, List<XContactData> existingContactResources,
      XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]) {

    _model = MUpsertCatalogueWindow(languageResources);

    _model.init(
        catalogue,
        agentCatalogsResources,
        peopleResources,
        organizationResources,
        existingContactResources,
        currentUserAccount,
        currentAgent,
        isPreview);

    _viewKey = GlobalKey<VUpsertCatalogueWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertCatalogueWindowFactory.get(_viewKey, _model));
  }

  // refresh available options for contacts dropdown
  @override
  void refreshContactResources(List<XContactData> agentContacts) {
    _model.refreshContactResources(agentContacts);
    _viewKey!.currentState?.refresh();
    _model.refreshContactsCounter();
  }

  // change "mode" to update if catalogue was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
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
  void refreshIcon(String iconUri, Uint8List iconFile) {
    _model.updateCatalogueIcon(iconUri, iconFile);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.catalogue.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewCatalogue}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
