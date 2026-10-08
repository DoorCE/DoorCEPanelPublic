import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_catalogues_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowCatalogues {
  showCataloguesSelected(BuildContext context, String? identifier);
  closeSelected(BuildContext context);
}

class UCShowCatalogues with ExceptionHandler implements IUCShowCatalogues {
  final IPCataloguesWindow pCataloguesWindow;
  final DatasetManagementAPI datasetManagement;
  final AgentManagementAPI agentManagement;

  const UCShowCatalogues(this.pCataloguesWindow, this.datasetManagement, this.agentManagement);

  @override
  showCataloguesSelected(BuildContext context, String? identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XCatalogue parentCatalogResources;
      if (identifier == null || identifier!.isEmpty) {
        parentCatalogResources = await datasetManagement.getCatalog(identifier);
        identifier = parentCatalogResources.identifier;
      } else {
        parentCatalogResources = await datasetManagement.getCatalog(identifier);
      }

      List<XOwnableResource> catalogsResources =
          await datasetManagement.getCataloguesInCatalogue(identifier);
      List<XOwnableResource> datasetsResources =
          await datasetManagement.getDatasetsInCatalogue(identifier);
      List<XOwnableResource> seriesResources =
          await datasetManagement.getSeriesInCatalogue(identifier);
      List<XOwnableResource> servicesResources =
          await datasetManagement.getServicesInCatalogue(identifier);

      List<XPerson> persons = await agentManagement.getPersons("");
      List<XOrganization> organisations = await agentManagement.getOrganizations("");
      WaitMessage().dismiss();

      pCataloguesWindow.show(context, catalogsResources, datasetsResources,
          seriesResources, servicesResources, parentCatalogResources, persons, organisations);
    });
  }

  @override
  closeSelected(BuildContext context) async {
    await pCataloguesWindow.close(context);
  }
}
