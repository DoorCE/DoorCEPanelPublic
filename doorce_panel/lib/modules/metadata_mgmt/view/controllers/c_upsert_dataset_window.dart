import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/publish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_dataset_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUpsertDatasetWindow {
  final MUpsertDatasetWindow? _model;
  
  const CUpsertDatasetWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context.read<IUCShowCatalogues>().showCataloguesSelected(context, identifier);
  }

  Future<void> saveSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCShowUpsertDataset>()
      .upsertDataset(context, _model.getDataset(context), _model.getNewContacts(), _model.isInsert);
  }

  Future<void> insertAndCreateDefaultAppSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCShowUpsertDataset>()
      .upsertDataset(context, _model.getDataset(context), _model.getNewContacts(), true, addApp: true);
  }

  void pickIconSelected(BuildContext context) {
    context.read<IUCShowUpsertDataset>().pickIconSelected(context);
  }

  Future<void> contactSourcesChanged(BuildContext context) async {
    final agentIds = <String>{}; 
    XDataset dataset = _model!.getDataset(context); 

    if (dataset.responsiblePersonID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }
    if (dataset.responsibleOrganisationID case final id?) {
      if (id.isNotEmpty) {
        agentIds.add(id);
      }
    }

    final editors = dataset.editorIDList;
      if (editors.isNotEmpty) {
        agentIds.addAll(editors);
      }

    await context.read<IUCShowUpsertDataset>().contactSourcesChanged(agentIds.toList());
  }

  Future<void> statusOrSchemaChanged(BuildContext context) async {
    await context.read<IUCShowUpsertDataset>().statusOrSchemaChanged(_model!.dataset.status, _model.dataset.schemaID);
  }

  Future<void> publishMetadataSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCPublishDataset>()
      .saveAndPublishDatasetSelected(context, _model.getDataset(context), _model.getNewContacts(), _model.isInsert);
  }

  Future<void> publishDataSelected(BuildContext context) async {
    _model!.updateNewContactsIdentifiers(); // Ensure contact identifiers are unique before saving
    return await context.read<IUCPublishDataset>()
      .saveAndPublishDatasetSelected(context, _model.getDataset(context), _model.getNewContacts(), _model.isInsert, withData: true);
  }

  Future<void> cancelSelected(BuildContext context) async {
    return await context.read<IUCShowUpsertDataset>().closeSelected(context);
  }
}