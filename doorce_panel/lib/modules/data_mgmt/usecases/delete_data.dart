import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteData {
  Future<void> clearData(BuildContext context, String datasetIdentifier);
}

class UCDeleteData extends UCShowDatasetContent implements IUCDeleteData {

  const UCDeleteData(super.pDatasetContentWindow, super.datasetManagement,
   super.agentManagement, super.vocabularyManagement, super.iconAPI, super.schemaAPI, super.dataUploadAPI, super.appManagement);

  @override
  Future<void> clearData(BuildContext context, String datasetIdentifier) async {
    DialogResult response = await showDeleteDialog(context, "${AppLocalizations.of(context)!.clearData}: $datasetIdentifier");
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await dataUploadAPI.deleteData(datasetIdentifier);
      int code = response.statusCode;
      
      if (200 == code) {
        pDatasetContentWindow.refreshConceptSummaries({});
        SnackMessage().show(context, false ,text: AppLocalizations.of(context)!.dataDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.dataDeleteError);}
      WaitMessage().dismiss();
    });
  }
}
