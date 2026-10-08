import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/namespace.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_schema_window.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertSchema {
  showUpsertSchemaSelected(BuildContext context, String? identifier, [bool? isPreview]);
  Future<void> upsertSchema(BuildContext context, XDataSchema schema, bool isInsert);
  closeSelected(BuildContext context);
}

class UCShowUpsertSchema with ExceptionHandler implements IUCShowUpsertSchema {
  final IPUpsertSchemaWindow _pUpsertSchemaWindow;
  final SchemaAPI _schemaManagement;
  final DatasetManagementAPI _datasetManagement;

  const UCShowUpsertSchema(this._pUpsertSchemaWindow, this._schemaManagement, this._datasetManagement);

  @override
  void showUpsertSchemaSelected(BuildContext context, String? identifier, [bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XSchemaSeries> seriesResources;
      List<XNamespace> standardNamespaces = await _schemaManagement.getStandardNamespaces();
      XDataSchema schema;
      List<XDataset>? datasets;

      if (identifier == null || identifier.isEmpty) {
        schema = XDataSchema();
        seriesResources = await _schemaManagement.getAllowedSchemaSeries("");
      } else {
        schema = await _schemaManagement.getDataSchema(identifier);
        seriesResources = await _schemaManagement.getAllowedSchemaSeries(identifier);
        datasets = await _datasetManagement.getSchemaDatasets(identifier);
      }
      WaitMessage().dismiss();

      _pUpsertSchemaWindow.show(context, schema, seriesResources, standardNamespaces, datasets, isPreview);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertSchemaWindow.close(context);
  }

  @override
  Future<void> upsertSchema(BuildContext context, XDataSchema schema, bool isInsert) async {
    if (isInsert && !await _schemaManagement.checkSchemaId(schema.identifier)){
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
      return;
    }
    
    await tryForApiExceptions(context, () async {
      Response response = await _schemaManagement.upsertDataSchema(schema);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.schemaUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.schemaError);}

      _pUpsertSchemaWindow.refreshIsInsert(code);
    });
  }
}