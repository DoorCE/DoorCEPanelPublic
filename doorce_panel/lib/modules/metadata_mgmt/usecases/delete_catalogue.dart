import 'package:doorce_panel/common/view_elements/selection_dialog.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCDeleteCatalogue {
  deleteCatalogueSelected(BuildContext context, String identifier);
}

class UCDeleteCatalogue extends UCShowCatalogues implements IUCDeleteCatalogue {
  
  UCDeleteCatalogue(super.pCataloguesWindow, super.datasetManagement, super.agentManagement);

  @override
  deleteCatalogueSelected(BuildContext context, String identifier) async {
    DialogResult response = await showDeleteDialog(context, identifier);
    if (0 != response.selection)
      return;
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XCatalogue catalogue = await datasetManagement.getCatalog(identifier);
      Response response = await datasetManagement.deleteCatalogue(identifier);
      int code = response.statusCode;

      if (200 == code) {
        List<XOwnableResource> catalogues = await datasetManagement.getCataloguesInCatalogue(catalogue.parentID ?? "");
        pCataloguesWindow.refreshResources(catalogues);
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.catalogueDeleted);
      } else if (403 == code) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.catalogueDeleteError);}
      WaitMessage().dismiss();
    });
  }
}
