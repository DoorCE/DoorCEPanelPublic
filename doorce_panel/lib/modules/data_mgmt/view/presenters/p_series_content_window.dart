import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_series_content_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/data_mgmt/view/series_content_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPSeriesContentWindow {
  show(
      BuildContext context,
      XDatasetSeries series,
      List<XContactData> seriesContactsResources,
      List<Language> languageResources,
      List<XDataset> datasetResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources);
  close(BuildContext context);
  void refreshDatasets(List<XDataset> newResourceList);
}

class PSeriesContentWindow extends AbstractPresenter
    implements IPSeriesContentWindow {
  final VSeriesContentWindowFactory _vSeriesContentWindowFactory;
  GlobalKey<VSeriesContentWindowState>? _viewKey;
  late MSeriesContentWindow _model;
  PSeriesContentWindow(this._vSeriesContentWindowFactory) : super(RoutingPrefixes.seriesContent);
  
  @override
  show(
      BuildContext context,
      XDatasetSeries series,
      List<XContactData> seriesContactsResources,
      List<Language> languageResources,
      List<XDataset> datasetResources,
      List<Licence> licenceResources,
      List<DatasetTheme> themeResources,
      List<Frequency> frequencyResources) {
    _model = MSeriesContentWindow(
        series,
        seriesContactsResources,
        languageResources,
        datasetResources,
        licenceResources,
        themeResources,
        frequencyResources);

    _viewKey = GlobalKey<VSeriesContentWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}",
        false,
        _vSeriesContentWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  void refreshDatasets(List<XDataset> newResourceList) {
    _model.refreshDatasetList(newResourceList);
    _viewKey!.currentState?.refresh();
  }

  @override
  String getRoutingName(){
    var identifier = _model.series.identifier;
    return "${super.getRoutingName()}:$identifier";
  }
}
