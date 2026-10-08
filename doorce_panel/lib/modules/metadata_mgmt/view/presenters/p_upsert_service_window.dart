import 'dart:typed_data';

import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_service_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

abstract interface class IPUpsertServiceWindow {
  show(
      BuildContext context,
      XDatasetService datasetService,
      List<Language> languageResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<String> formatResources,
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

class PUpsertServiceWindow extends AbstractPresenter
    implements IPUpsertServiceWindow {
  final VUpsertServiceWindowFactory _vUpsertServicesWindowFactory;
  GlobalKey<VUpsertServiceWindowState>? _viewKey;
  late MUpsertServiceWindow _model;
  PUpsertServiceWindow(this._vUpsertServicesWindowFactory) : super(RoutingPrefixes.upsertService);

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XDatasetService datasetService, List<Language> languageResources, List<Licence> licenceResources,
      List<DatasetTheme> themeResources, List<XCatalogue> agentCatalogsResources, List<XPerson> peopleResources,
      List<XOrganization> organizationResources, List<String> formatResources, List<XContactData> existingContactResources,
      XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]) 
    {
    _model = MUpsertServiceWindow(languageResources, licenceResources, themeResources, formatResources);

    _model.init(
        datasetService,
        agentCatalogsResources,
        peopleResources,
        organizationResources,
        existingContactResources,
        currentUserAccount,
        currentAgent,
        isPreview);

    _viewKey = GlobalKey<VUpsertServiceWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertServicesWindowFactory.get(_viewKey, _model));
  }

  // refresh available options for contacts dropdown
  @override
  void refreshContactResources(List<XContactData> agentContacts) {
    _model.refreshContactResources(agentContacts);
    _viewKey!.currentState?.refresh();
    _model.refreshContactsCounter();
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
  void refreshIcon(String iconUri, Uint8List iconFile) {
    _model.updateServiceIcon(iconUri, iconFile);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.service.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewService}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}