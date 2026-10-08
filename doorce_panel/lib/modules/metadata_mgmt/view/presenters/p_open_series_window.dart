import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/open_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_series_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPOpenSeriesWindow {
  show(BuildContext context, List<XDataset> seriesContentResources, XDatasetSeries series, List<XPerson> persons, List<XOrganization> organizations);
  close(BuildContext context);
}

class POpenSeriesWindow extends AbstractPresenter
    implements IPOpenSeriesWindow {
  final VOpenSeriesWindowFactory _vSeriesContentWindowFactory;
  late MOpenSeriesWindow? _model;
  POpenSeriesWindow(this._vSeriesContentWindowFactory) : super(RoutingPrefixes.openDatasetSeries);

  @override
  show(BuildContext context, List<XDataset> seriesContentResources, XDatasetSeries series, List<XPerson> persons, List<XOrganization> organizations) {
    _model =
        MOpenSeriesWindow(seriesContentResources, series, persons, organizations);
    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}",
        false,
        _vSeriesContentWindowFactory.get(_model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  String getRoutingName(){
    var identifier = _model!.getSeriesId();
    return "${super.getRoutingName()}:$identifier";
  }
}
