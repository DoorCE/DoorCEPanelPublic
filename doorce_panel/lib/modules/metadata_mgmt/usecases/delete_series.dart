import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteSeries {
  deleteSeriesSelected(BuildContext context, String identiier);
}

class UCDeleteSeries extends UCShowCatalogues implements IUCDeleteSeries {
  
  UCDeleteSeries(super.pCataloguesWindow, super.datasetManagement, super.agentManagement);

  @override
  deleteSeriesSelected(BuildContext context, String identifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XDatasetSeries series = await datasetManagement.getSeries(identifier);
      Response response = await datasetManagement.deleteSeries(identifier);
      int code = response.statusCode;

      if ( 200 == code) {
        List<XOwnableResource> seriesResources = await datasetManagement.getSeriesInCatalogue(series.catalogueID);
        pCataloguesWindow.refreshResources(seriesResources);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.seriesDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.seriesDeleteError);}
      WaitMessage().dismiss();
    });
  }
}