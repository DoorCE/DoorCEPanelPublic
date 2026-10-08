import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteService {
  deleteServiceSelected(BuildContext context, String identiier);
}

class UCDeleteService extends UCShowCatalogues implements IUCDeleteService {
  
  UCDeleteService(super.pCataloguesWindow, super.datasetManagement, super.agentManagement);

  @override
  deleteServiceSelected(BuildContext context, String identifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XDatasetService service = await datasetManagement.getDataService(identifier);
      Response response = await datasetManagement.deleteService(identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XOwnableResource> services = await datasetManagement.getServicesInCatalogue(service.catalogueID);
        pCataloguesWindow.refreshResources(services);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.serviceDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.serviceDeleteError);}
      WaitMessage().dismiss();
    });
  }
}