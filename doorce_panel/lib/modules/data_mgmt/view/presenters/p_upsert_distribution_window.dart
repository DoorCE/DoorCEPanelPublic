import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/maturity_status.dart';
import 'package:doorce_panel/modules/data_mgmt/view/upsert_distribution_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_upsert_distribution_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertDistributionWindow {
  show(
      BuildContext context,
      XDataset dataset,
      XDistribution distribution,
      List<Language> languageResources,
      List<String> formatResources,
      List<String> mediaTypeResources,
      List<XDataset> agentDatasetResources,
      List<XDatasetService> agentServiceResources,
      List<MaturityStatus> maturityStatusResources,
      XFileData? fileData,
      List<XDataSchema> schemaResources);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult);
}

class PUpsertDistributionWindow extends AbstractPresenter
    implements IPUpsertDistributionWindow {
  final VUpsertDistributionWindowFactory _vUpsertDistributionWindowFactory;
  GlobalKey<VUpsertDistributionWindowState>? _viewKey;
  late MUpsertDistributionWindow _model;
  PUpsertDistributionWindow(this._vUpsertDistributionWindowFactory) : super(RoutingPrefixes.upsertDistribution);

  @override
  close(BuildContext context) => popWindow(context);

  @override
  show(BuildContext context, XDataset dataset, XDistribution distribution,
      List<Language> languageResources, List<String> formatResources, List<String> mediaTypeResources,
      List<XDataset> agentDatasetResources, List<XDatasetService> agentServiceResources,
      List<MaturityStatus> maturityStatusResources, XFileData? fileData, List<XDataSchema> schemaResources) {
        
    _model = MUpsertDistributionWindow(
        languageResources,
        formatResources,
        mediaTypeResources,
        maturityStatusResources);

    _model.init(
        dataset,
        distribution,
        agentDatasetResources,
        agentServiceResources,
        fileData,
        schemaResources);

    _viewKey = GlobalKey<VUpsertDistributionWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertDistributionWindowFactory.get(_viewKey, _model));
  }

  // change "mode" to update if dataset was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
  }

  @override
  String getRoutingName(){
    var identifier = _model.distribution.identifier;
    var datasetIdentifier = _model.dataset.identifier;
    return "${super.getRoutingName()}:$datasetIdentifier${identifier.isNotEmpty ? ":$identifier" : ""}";
  }
}
