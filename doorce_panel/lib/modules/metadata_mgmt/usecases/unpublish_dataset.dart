import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/dtos/ckan_result.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IUCUnpublishDataset {
  unpublishDatasetSelected(BuildContext context, XDataset dataset);
}

class UCUnpublishDataset extends UCShowCatalogues implements IUCUnpublishDataset {

  UCUnpublishDataset(super.pCataloguesWindow, super.datasetManagement, super.agentManagement);

  @override
  unpublishDatasetSelected(BuildContext context, XDataset dataset) async {
    if (0 != await showUnpublishDialog(context, dataset.identifier, dataset.status == DatasetStatus.independent))
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XCkanResult response = await datasetManagement.unpublishDataset(context, dataset.identifier);

      if (response.isSuccess) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.datasetUnpublished);
      } else {
        SnackMessage().show(context, true, 
          text: "${AppLocalizations.of(context)!.datasetUnpublishError} ${response.errorMessage}");
      }
      WaitMessage().dismiss();
    });
  }
}