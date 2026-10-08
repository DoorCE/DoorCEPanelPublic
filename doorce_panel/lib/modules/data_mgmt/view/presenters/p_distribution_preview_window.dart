import 'dart:typed_data';

import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/modules/data_mgmt/view/distribution_preview_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_distribution_preview_window.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPDistributionPreviewWindow {
  show(BuildContext context, XDistribution distributionResource,
      List<Language> languageResources, Uint8List? fileContent, [bool pathFromMetadataMgmt = true]);
  close(BuildContext context);
}

class PDistributionPreviewWindow extends AbstractPresenter
    implements IPDistributionPreviewWindow {
  final VDistributionPreviewWindowFactory _vDistributionContentWindowFactory;
  GlobalKey<VDistributionPreviewWindowState>? _viewKey;
  late MDistributionPreviewWindow _model;
  PDistributionPreviewWindow(this._vDistributionContentWindowFactory) : super(RoutingPrefixes.previewDistribution);

  @override
  show(BuildContext context, XDistribution distributionResource,
      List<Language> languageResources, Uint8List? fileContent, [bool pathFromMetadataMgmt = true]) {
    _model = MDistributionPreviewWindow(distributionResource, languageResources, fileContent, pathFromMetadataMgmt);

    _viewKey = GlobalKey<VDistributionPreviewWindowState>();
    pushWindow(
        context, "", "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}",
        false, _vDistributionContentWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  @override
  String getRoutingName(){
    var identifier = _model.getDistributionIdentifier();
    return "${super.getRoutingName()}:$identifier";
  }
}
