import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/ckan_result.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteDataset {
  deleteDatasetSelected(BuildContext context, XDataset dataset);
}

class UCDeleteDataset extends UCShowCatalogues implements IUCDeleteDataset {

  UCDeleteDataset(super.pCataloguesWindow, super.datasetManagement, super.agentManagement);

  @override
  deleteDatasetSelected(BuildContext context, XDataset dataset) async {
    DialogResult response = await showDeleteDialog(context, dataset.identifier, true, dataset.status == DatasetStatus.independent);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      String identifier = dataset.identifier;

      XCkanResult unpublishResult = XCkanResult();
      if (response.checked) {
        unpublishResult = await datasetManagement.unpublishDataset(context, identifier);
      }

      if (unpublishResult.isSuccess) {

        Response response = await datasetManagement.deleteDataset(identifier);
        int deleteCode = response.statusCode;

        if (200 == deleteCode) {
          List<XOwnableResource> datasets = await datasetManagement.getDatasetsInCatalogue(dataset.catalogueID);
          pCataloguesWindow.refreshResources(datasets.length > 0 ? datasets : List<XDataset>.empty());
          SnackMessage().show(context, false, text: AppLocalizations.of(context)!.datasetDeleted);
        } else if (403 == deleteCode) {
          SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
        } else {
          SnackMessage().show(context, true, text: AppLocalizations.of(context)!.datasetDeleteError);
        }
      } else {
        SnackMessage().show(context, true, 
          text: "${AppLocalizations.of(context)!.datasetUnpublishError} ${unpublishResult.errorMessage}");
      }
      WaitMessage().dismiss();
    });
  }

}