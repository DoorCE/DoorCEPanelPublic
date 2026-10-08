import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_service_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertServiceWindow {
  final MUpsertServiceWindow? _model;
  
  const CUpsertServiceWindow(this._model);

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
    return await context.read<IUCShowUpsertService>()
      .upsertService(context, _model.service, _model.newContacts, _model.isInsert);
  }

  void pickIconSelected(BuildContext context) {
    context.read<IUCShowUpsertService>().pickIconSelected(context);
  }

  Future<void> contactSourcesChanged(BuildContext context) async {
    final agentIds = <String>{}; 
    XDatasetService service = _model!.service; 

    if (service.responsiblePersonID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }
    if (service.responsibleOrganisationID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }

    final editors = service.editorIDList;
      if (editors.isNotEmpty) {
        agentIds.addAll(editors);
      }

    await context.read<IUCShowUpsertService>().contactSourcesChanged(agentIds.toList());
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertService>().closeSelected(context);
  }
}
