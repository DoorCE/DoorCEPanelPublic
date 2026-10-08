import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/ckan_result.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCPublishDataset {
  Future<void> publishDatasetSelected(BuildContext context, String identifier, {bool withData = false});
  Future<void> saveAndPublishDatasetSelected(BuildContext context, XDataset xDataset, List<XContactData> newContacts, bool isInsert, 
    {bool withData = false});
}

class UCPublishDataset extends UCShowUpsertDataset implements IUCPublishDataset {

  UCPublishDataset(super.pUpsertDatasetWindow, super.datasetManagement, super._vocabularyManagement,
    super._agentManagement, super._iconAPI, super._schemaManagement, super._dataUploadAPI);

  Future<void>_publishDataset(BuildContext context, String identifier, {bool withData = false}) async {
      XCkanResult result = await datasetManagement.publishDataset(context, identifier, withData: withData);

      if (result.isSuccess) {
        String dataResult = withData ? _createDatastorePublishString(context, result) : "";
        SnackMessage().show(context, false,
          text: "${AppLocalizations.of(context)!.datasetPublished}$dataResult");
      } else {
        SnackMessage().show(context, true, 
          text: "${AppLocalizations.of(context)!.datasetPublishError} ${result.errorMessage}");
      }
  }

  String _createDatastorePublishString(BuildContext context, XCkanResult result) {

    if (!result.isSuccess || result.upsertedRows == null || result.upsertedRows!.isEmpty) {
      return "";
    }

    return "\n${AppLocalizations.of(context)!.upsertedRows}:\n" 
      + result.upsertedRows!.entries.map((conceptRows) => "${conceptRows.key}: ${conceptRows.value}").join("\n");
  }

  // only for upsert dataset window, not for list views
  @override
  Future<void> saveAndPublishDatasetSelected(BuildContext context, XDataset xDataset, List<XContactData> newContacts,
  bool isInsert, {bool withData = false}) async {
    if (0 != await showPublishDialog(context, xDataset.identifier))
      return;
    await tryForApiExceptions(context, () async {
      if (isInsert && !await datasetManagement.checkDatasetId(xDataset.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response responseUpsert = await datasetManagement.upsertDataset(xDataset, newContacts);
      if (200 == responseUpsert.statusCode) {
        await _publishDataset(context, xDataset.identifier, withData: withData);
      } else if (responseUpsert.statusCode == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.datasetError);}

      pUpsertDatasetWindow.refreshIsInsert(responseUpsert.statusCode);
      pUpsertDatasetWindow.refreshUserRoles(responseUpsert.statusCode);
    });
  }

  // might be used in list views
  @override
  Future<void> publishDatasetSelected(BuildContext context, String identifier, {bool withData = false}) async {
    if (0 != await showPublishDialog(context, identifier))
      return;
    await tryForApiExceptions(context, () async { 
      WaitMessage().show(context);
      await _publishDataset(context, identifier, withData: withData);
      WaitMessage().dismiss();
    });
  }
}