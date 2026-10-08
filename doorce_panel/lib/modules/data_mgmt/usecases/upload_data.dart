import 'package:doorce_panel/common/view_elements/concept_dialog.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/data_upload_request.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCUploadData {
  Future<XDataUploadRequest?> showDataUploadRequestDialog(BuildContext context, List<XConcept> concepts);
  Future<void> uploadDataSelected(BuildContext context, List<XConcept> concepts, String datasetUri, XFileData fileData);
}
  
class UCUploadData extends UCShowDatasetContent implements IUCUploadData {

  const UCUploadData(super.pDatasetContentWindow, super.datasetManagement,
   super.vocabularyManagement, super.storageAPI, super.iconAPI, super.schemaAPI, super.dataUploadAPI, super.appManagement);

  @override
  Future<XDataUploadRequest?> showDataUploadRequestDialog(BuildContext context, List<XConcept> concepts) async {
    return await showConceptDialog(
        context: context,
        concepts: concepts,
      );
  }

  @override
  Future<void> uploadDataSelected(BuildContext context, List<XConcept> concepts, String datasetUri, XFileData fileData) async {
  
    await tryForApiExceptions(context, () async {
      XDataUploadRequest? dataUploadRequest = await showDataUploadRequestDialog(context, concepts);

      if (dataUploadRequest == null) {
        return;
      }

      dataUploadRequest.datasetUri = datasetUri;
      dataUploadRequest.fileUrl = fileData.downloadUrl ?? null;

      WaitMessage().show(context);
      Response response = await dataUploadAPI.upsertData(fileData, dataUploadRequest);
      int code = response.statusCode;
      
      if (200 == code) {
        pDatasetContentWindow.refreshDataLoaded();
        pDatasetContentWindow.refreshConceptSummaries(await dataUploadAPI.getDataItemCounts(datasetUri));
        SnackMessage().show(context, false ,text: AppLocalizations.of(context)!.dataUploaded);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else if (400 == code) {
        pDatasetContentWindow.refreshErrorString(response.body);
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.dataUploadError);
      } else {
        pDatasetContentWindow.refreshErrorString("");
        response.body.isNotEmpty
          ? SnackMessage().show(context, true, text: response.body)
          : SnackMessage().show(context, true, text: AppLocalizations.of(context)!.dataUploadError);}
      WaitMessage().dismiss();
    });
  }
}
