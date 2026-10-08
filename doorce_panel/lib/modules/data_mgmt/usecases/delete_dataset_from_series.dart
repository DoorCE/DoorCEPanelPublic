import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_series_content.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteDatasetFromSeries {
  deleteDatasetSelected(BuildContext context, String identifier, String seriesIdentifier);
}

class UCDeleteDatasetFromSeries extends UCShowSeriesContent implements IUCDeleteDatasetFromSeries {
  
  UCDeleteDatasetFromSeries(super.pSeriesDetailsWindow, super.datasetManagement, super.agentManagement,
      super.vocabularyManagement, super.iconAPI);

  @override
  deleteDatasetSelected(BuildContext context, String identifier, String seriesIdentifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      Response response = await datasetManagement.deleteDataset(identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XDataset> datasets = await datasetManagement.getSeriesDatasetList(seriesIdentifier);
        pSeriesDetailsWindow.refreshDatasets(datasets);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.datasetDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.datasetDeleteError);}
      WaitMessage().dismiss();
    });
  }
}