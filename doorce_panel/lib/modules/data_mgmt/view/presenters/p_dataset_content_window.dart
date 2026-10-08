import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/modules/data_mgmt/view/dataset_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_dataset_content_widow.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPDatasetContentWindow {
  show(
      BuildContext context,
      XDataset datasetResources,
      List<XContactData> datasetContactsResources,
      List<Language> languageResources,
      List<XDistribution> distributionResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources,
      Map<String, int> conceptSummaries,
      List<XConcept> concepts,
      List<XApp> datasetApps,
      XApp? defaultApp);
  close(BuildContext context);
  void refreshDistributions(List<XDistribution> newResourceList);
  void refreshDataLoaded();
  void refreshConceptSummaries(Map<String, int> newSummaries);
  void refreshErrorString(String errorString);
}

class PDatasetContentWindow extends AbstractPresenter
    implements IPDatasetContentWindow {
  final VDatasetContentWindowFactory _vDatasetContentWindowFactory;
  GlobalKey<VDatasetContentWindowState>? _viewKey;
  late MDatasetContentWindow _model;
  PDatasetContentWindow(this._vDatasetContentWindowFactory) : super(RoutingPrefixes.datasetContent);

  @override
  show(
      BuildContext context,
      XDataset datasetResources,
      List<XContactData> datasetContactsResources,
      List<Language> languageResources,
      List<XDistribution> distributionResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources,
      Map<String, int> conceptSummaries,
      List<XConcept> concepts,
      List<XApp> datasetApps,
      XApp? defaultApp) {
    _model = MDatasetContentWindow(
        datasetResources,
        datasetContactsResources,
        languageResources,
        distributionResources,
        licenceResources,
        themeResources,
        frequencyResources,
        conceptSummaries,
        concepts,
        datasetApps,
        defaultApp);

    _viewKey = GlobalKey<VDatasetContentWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}",
        false,
        _vDatasetContentWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void refreshDistributions(List<XDistribution> newResourceList) {
    _model.refreshDistributionList(newResourceList);
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshDataLoaded() {
    _model.fileErrorString = "";
    _model.fileData = null;
  }

  @override
  void refreshConceptSummaries(Map<String, int> newSummaries) {
    _model.conceptSummaries = newSummaries;
    _viewKey!.currentState?.refresh();
  }

  @override
  void refreshErrorString(String errorString) {
    _model.fileErrorString = errorString;
  }

  @override
  String getRoutingName(){
    var identifier = _model.dataset.identifier;
    return "${super.getRoutingName()}:$identifier";
  }
}
