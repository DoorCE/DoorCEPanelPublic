import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_catalogue.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/publish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_open_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_open_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_catalogue.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/unpublish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_catalogues_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CCataloguesWindow {
  final MCataloguesWindow? _model;
  
  const CCataloguesWindow(this._model);

  homeSelected(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }

  showCataloguesSelected(BuildContext context, String identifier) {
    context.read<IUCShowCatalogues>().showCataloguesSelected(context, identifier);
  }

  upsertCatalogueSelected(BuildContext context, String identifier, [String? parentId]) {
    context.read<IUCShowUpsertCatalogue>().showUpsertCatalogueSelected(context, identifier, parentId);
  }

  deleteCatalogueSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteCatalogue>().deleteCatalogueSelected(context, identifier);
  }

  upsertDatasetSelected(BuildContext context, String identifier, [String? parent]) {
    context.read<IUCShowUpsertDataset>().showUpsertDatasetSelected(context, identifier, parent);
  }

  publishDatasetMetadataSelected(BuildContext context, XDataset dataset) {
    context.read<IUCPublishDataset>().publishDatasetSelected(context, dataset.identifier, withData: false);
  }

  publishDatasetDataSelected(BuildContext context, XDataset dataset) {
    context.read<IUCPublishDataset>().publishDatasetSelected(context, dataset.identifier, withData: true);
  }

  unpublishDatasetSelected(BuildContext context, XDataset dataset) {
    context.read<IUCUnpublishDataset>().unpublishDatasetSelected(context, dataset);
  }

  deleteDatasetSelected(BuildContext context, XDataset dataset) {
    context.read<IUCDeleteDataset>().deleteDatasetSelected(context, dataset);
  }

  upsertDatasetSeriesSelected(BuildContext context, String identifier, [String? parent]) {
    context.read<IUCShowUpsertSeries>().showUpsertSeriesSelected(context, identifier, parent);
  }

  deleteDatasetSeriesSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteSeries>().deleteSeriesSelected(context, identifier);
  }

  openSeriesContent(BuildContext context, String identifier) {
    context.read<IUCShowOpenSeries>().showSeriesContentSelected(context, identifier);
  }

  openServicesContent(
      BuildContext context, String identifier) {
    context.read<IUCShowOpenService>().showServicesContentSelected(context, identifier);
  }

  upsertDatasetServicesSelected(BuildContext context, String identifier, [String? parent]) {
    context.read<IUCShowUpsertService>().showUpsertServiceSelected(context, identifier, parent);
  }

  deleteDataServiceSelected(BuildContext context, String identifier) {
    context.read<IUCDeleteService>().deleteServiceSelected(context, identifier);
  }

  previewDatasetSelected(BuildContext context, String identifier, [String? parent]) {
    context.read<IUCShowUpsertDataset>().showUpsertDatasetSelected(context, identifier, parent, null, true);
  }

  previewSeriesSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertSeries>().showUpsertSeriesSelected(context, identifier, null, true);
  }

  previewServiceSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertService>().showUpsertServiceSelected(context, identifier, null, true);
  }

  previewCatalogueSelected(BuildContext context, String identifier) {
    context.read<IUCShowUpsertCatalogue>().showUpsertCatalogueSelected(context, identifier, null, true);
  }
}