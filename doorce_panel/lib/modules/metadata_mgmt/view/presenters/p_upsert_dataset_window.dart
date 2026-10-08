import 'dart:typed_data';

import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_dataset_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_dataset_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

abstract interface class IPUpsertDatasetWindow {
  show(
      BuildContext context,
      XDataset dataset,
      List<Language> languageResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<XDatasetSeries> agentSeriesResources,
      List<XContactData> existingContactResources,
      List<XDataSchema> schemaResources,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      List<XDataset> targetDatasetResources,
      Map<String, int>? itemCountsByConcept,
      bool? preview
      );
  close(BuildContext context);

  void refreshContactResources(List<XContactData> agentContacts) {}
  void refreshTargetDatasetResources(List<XDataset> targetDatasets) {}
  void refreshTargetDatasetId(List<XDataset> targetDatasets) {}
  void refreshIsInsert(int upsertResult) {}
  void refreshUserRoles(int statusCode) {}
  void refreshIcon(String iconUri, Uint8List iconFile) {}
}

class PUpsertDatasetWindow extends AbstractPresenter
    implements IPUpsertDatasetWindow {
  final VUpsertDatasetWindowFactory _vUpsertDatasetWindowFactory;
  GlobalKey<VUpsertDatasetWindowState>? _viewKey;
  late MUpsertDatasetWindow _model;
  PUpsertDatasetWindow(this._vUpsertDatasetWindowFactory) : super(RoutingPrefixes.upsertDataset);

  @override
  String getRoutingName(){
    var identifier = _model.dataset.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewDataset}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }

  @override
  show(BuildContext context, XDataset dataset, List<Language> languageResources,
      List<Licence> licenceResources, List<DatasetTheme> themeResources, List<Frequency> frequencyResources,
      List<XCatalogue> agentCatalogsResources, List<XPerson> peopleResources, List<XOrganization> organizationResources,
      List<XDatasetSeries> agentSeriesResources, List<XContactData> existingContactResources, List<XDataSchema> schemaResources,
      XUserAccount currentUserAccount, XAgent? currentAgent, List<XDataset> targetDatasetResources, Map<String, int>? itemCountsByConcept, bool? preview)
  {
    _model = MUpsertDatasetWindow(
        languageResources,
        licenceResources,
        themeResources,
        frequencyResources);

    _model.init(
        dataset,
        agentCatalogsResources,
        peopleResources,
        organizationResources,
        agentSeriesResources,
        existingContactResources,
        schemaResources,
        currentUserAccount,
        currentAgent,
        targetDatasetResources,
        itemCountsByConcept,
        preview ?? false);

    _viewKey = GlobalKey<VUpsertDatasetWindowState>();

    pushWindow(context, 
      'images/catalogue.png', 
      "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}", 
      false,
      _vUpsertDatasetWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) {
     popWindow(context);
  }
  
  // refresh available options for contacts dropdown
  @override
  void refreshContactResources(List<XContactData> agentContacts) {
    _model.refreshContactResources(agentContacts);
    _viewKey!.currentState?.refresh();
    _model.refreshContactsCounter();
  }

  @override
  void refreshTargetDatasetResources(List<XDataset> datasets) {
    _model.targetDatasetResources = datasets;
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshTargetDatasetId(List<XDataset> datasets) {
    _model.refreshTargetDatasetId(datasets);
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
    _model.updateDatasetIcon(iconUri, iconFile);
    _viewKey!.currentState?.refresh();
  }
}