import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/data_mgmt/view/data_management_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_data_management_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPDataManagementWindow {
  show(BuildContext context, List<XDataset> datasetsResources,
      List<XDatasetSeries> seriesResources, List<XPerson> persons, List<XOrganization> organisations);
  close(BuildContext context);
}

class PDataManagementWindow extends AbstractPresenter
    implements IPDataManagementWindow {
  final VDataManagementWindowFactory _vDataManagementWindowFactory;
  GlobalKey<VDataManagementWindowState>? _viewKey;
  late MDataManagementWindow _model;
  PDataManagementWindow(this._vDataManagementWindowFactory) : super(RoutingPrefixes.dataManagement);

  @override
  show(BuildContext context, List<XOwnableResource> datasetsResources,
      List<XOwnableResource> seriesResources, List<XPerson> persons, List<XOrganization> organisations) {
    _model = MDataManagementWindow(
      datasetsResources,
      seriesResources,
      persons, organisations
    );

    _viewKey = GlobalKey<VDataManagementWindowState>();

    pushWindow(
        context,
        "",
        "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}",
        false,
        _vDataManagementWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  String getRoutingName(){
    return super.getRoutingName();
  }
}
