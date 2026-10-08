import 'dart:typed_data';

import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_series_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertSeriesWindow
{
  void show(BuildContext context, XDatasetSeries datasetSeries,
      List<Language> languageResources, List<Licence> licenceResources, List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources, List<XCatalogue> agentCatalogsResources, List<XPerson> peopleResources,
      List<XOrganization> organizationResources, List<XContactData> existingContactResources,
      XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview]);
  close(BuildContext context);
  
  void refreshContactResources(List<XContactData> agentContacts) {}
  void refreshIsInsert(int upsertResult) {}
  void refreshUserRoles(int statusCode) {}
  void refreshIcon(String iconUri, Uint8List iconFile) {}
}

class PUpsertSeriesWindow extends AbstractPresenter implements IPUpsertSeriesWindow
{
  final VUpsertSeriesWindowFactory _vUpsertSeriesWindowFactory;
  GlobalKey<VUpsertSeriesWindowState>? _viewKey;
  late MUpsertSeriesWindow _model;
  PUpsertSeriesWindow(this._vUpsertSeriesWindowFactory) : super(RoutingPrefixes.upsertSeries);

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void show(BuildContext context, XDatasetSeries series,
      List<Language> languageResources, List<Licence> licenceResources, List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources, List<XCatalogue> agentCatalogsResources, List<XPerson> peopleResources,
      List<XOrganization> organizationResources, List<XContactData> existingContactResources,
      XUserAccount currentUserAccount, XAgent? currentAgent, [bool? isPreview])
  {
    _model = MUpsertSeriesWindow(
        languageResources,
        licenceResources,
        themeResources,
        frequencyResources);

    _model.init(
        series,
        agentCatalogsResources,
        peopleResources,
        organizationResources,
        existingContactResources,
        currentUserAccount,
        currentAgent,
        isPreview);

    _viewKey = GlobalKey<VUpsertSeriesWindowState>();

    pushWindow(context,
      "", 
      "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
      false,
      _vUpsertSeriesWindowFactory.get(_viewKey, _model));
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
    _model.updateSeriesIcon(iconUri, iconFile);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.series.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewDatasetSeries}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
