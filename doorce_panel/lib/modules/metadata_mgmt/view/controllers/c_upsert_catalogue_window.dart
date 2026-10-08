import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_catalogue.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_catalogue_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertCatalogueWindow {
  final MUpsertCatalogueWindow? _model;
  const CUpsertCatalogueWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context
        .read<IUCShowCatalogues>()
        .showCataloguesSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCShowUpsertCatalogue>()
      .upsertCatalogue(context, _model.catalogue, _model.newContacts, _model.isInsert);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertCatalogue>()
        .closeSelected(context);
  }

  void pickIconSelected(BuildContext context) {
    context.read<IUCShowUpsertCatalogue>().pickIconSelected(context);
  }

  Future<void> contactSourcesChanged(BuildContext context) async {
    final agentIds = <String>{}; 
    XCatalogue catalogue = _model!.catalogue;

    if (catalogue.responsiblePersonID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }
    if (catalogue.responsibleOrganisationID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }

    final editors = catalogue.editorIDList;
      if (editors.isNotEmpty) {
        agentIds.addAll(editors);
      }

    await context.read<IUCShowUpsertCatalogue>().contactSourcesChanged(agentIds.toList());
  }
}
