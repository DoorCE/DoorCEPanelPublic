import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteDistribution {
  Future<void> deleteDistributionSelected(BuildContext context, String identifier, String datasetIdentifier);
}
  
class UCDeleteDistribution extends UCShowDatasetContent implements IUCDeleteDistribution {

  const UCDeleteDistribution(super.pDatasetContentWindow, super.datasetManagement,
   super.agentManagement, super.vocabularyManagement, super.iconAPI, super.schemaAPI, super.dataUploadAPI, super.appManagement);

  @override
  Future<void> deleteDistributionSelected(BuildContext context, String identifier, String datasetIdentifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await datasetManagement.deleteDistribution(identifier);
      int code = response.statusCode;
      
      if (200 == code) {
        List<XDistribution> distributions = await datasetManagement.getDatasetDistributionList(datasetIdentifier);
        pDatasetContentWindow.refreshDistributions(distributions);
        SnackMessage().show(context, false ,text: AppLocalizations.of(context)!.distributionDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.distributionDeleteError);}
      WaitMessage().dismiss();
    });
  }
}
