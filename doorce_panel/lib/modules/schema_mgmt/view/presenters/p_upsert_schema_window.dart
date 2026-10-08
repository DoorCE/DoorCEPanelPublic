import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/namespace.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_schema_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPUpsertSchemaWindow {
  show(
      BuildContext context,
      XDataSchema schema,
      List<XSchemaSeries> schemaSeriesResources,
      List<XNamespace> standardNamespaces,
      List<XDataset>? datasets,
      [bool? isPreview]);
  close(BuildContext context);
  void refreshIsInsert(int upsertResult) {}
}

class PUpsertSchemaWindow extends AbstractPresenter
    implements IPUpsertSchemaWindow {
  final VUpsertSchemaWindowFactory _vUpsertSchemaWindowFactory;
  GlobalKey<VUpsertSchemaWindowState>? _viewKey;
  late MUpsertSchemaWindow _model;
  PUpsertSchemaWindow(this._vUpsertSchemaWindowFactory) : super(RoutingPrefixes.upsertSchema);

  @override
  show(BuildContext context, XDataSchema schema, List<XSchemaSeries> schemaSeriesResources, List<XNamespace> standardNamespaces, List<XDataset>? datasets, [bool? isPreview]) {
    _model = MUpsertSchemaWindow(schema, schemaSeriesResources, standardNamespaces, datasets, isPreview);

    _viewKey = GlobalKey<VUpsertSchemaWindowState>();

    pushWindow(
        context,
        'images/schema.png',
        "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}",
        false,
        _vUpsertSchemaWindowFactory.get(_viewKey, _model));
  }

  @override
  close(BuildContext context) => popWindow(context);

  // change "mode" to update if dataset was successfully inserted
  @override
  void refreshIsInsert(int statusCode) {
    if (200 == statusCode)
      _model.isInsert = false;
  }

  @override
  String getRoutingName(){
    var identifier = _model.schema.identifier;
    if (_model.isPreview) {
      return "${RoutingPrefixes.previewSchema}:$identifier";
    }
    return "${super.getRoutingName()}${identifier.isNotEmpty ? ':$identifier' : ''}";
  }
}
