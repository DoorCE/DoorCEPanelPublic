import 'dart:typed_data';

import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/common/view_elements/file_picker.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/icon_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_dataset_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/data_upload_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertDataset {
  showUpsertDatasetSelected(BuildContext context, String? identifier, String? parent, [String? defaultSeries, bool? preview]);
  Future<void> upsertDataset(BuildContext context, XDataset xDataset, List<XContactData> newContacts, bool isInsert, {bool addApp = false});
  Future<void> contactSourcesChanged(List<String> agentIds);
  Future<void> statusOrSchemaChanged(DatasetStatus status, String? schemaId);
  closeSelected(BuildContext context);
  void pickIconSelected(BuildContext context);

}

class UCShowUpsertDataset with ExceptionHandler implements IUCShowUpsertDataset {
  final IPUpsertDatasetWindow pUpsertDatasetWindow;
  final DatasetManagementAPI datasetManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final AgentManagementAPI _agentManagement;
  final IconAPI _iconAPI;
  final SchemaAPI _schemaManagement;
  final DataUploadAPI _dataUploadAPI;

  const UCShowUpsertDataset(this.pUpsertDatasetWindow, this.datasetManagement, this._vocabularyManagement,
    this._agentManagement, this._iconAPI, this._schemaManagement, this._dataUploadAPI);

  @override
  showUpsertDatasetSelected(BuildContext context, String? identifier, String? parent, [String? defaultSeries, bool? preview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);

      String locale = Localizations.localeOf(context).languageCode;
      List<XPerson> peopleResources = await _agentManagement.getPersons("");
      List<XOrganization> organizationResources = await _agentManagement.getOrganizations("");
      List<XCatalogue> agentCatalogsResources;
      List<XDatasetSeries> agentSeriesResources;
      List<Language> languageResources = await _vocabularyManagement.getLanguages(locale);
      List<Licence> licenceResources = await _vocabularyManagement.getLicences(locale);
      List<DatasetTheme> themeResources = await _vocabularyManagement.getThemes(locale);
      List<Frequency> frequencyResources = await _vocabularyManagement.getFrequencies(locale);
      List<XDataSchema> schemaResources = await _schemaManagement.getDataSchemaList(null);
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();
      Map<String, int>? itemCountsByConcept;
          
      List<XContactData> existingContactResources = [];

      List<XDataset> targetDatasetResources = [];

      XDataset dataset;
      if (identifier == null || identifier.isEmpty) {
        dataset = XDataset.forInsert();
        dataset.catalogueID = parent ?? "";
        if (null != defaultSeries) dataset.seriesID.add(defaultSeries);
        agentCatalogsResources = await datasetManagement.getAllowedCatalogues(null);
        agentSeriesResources = await datasetManagement.getAllowedSeries(null);
      } else {
        dataset = await datasetManagement.getDataset(identifier);
        existingContactResources = await _agentManagement.getResourceContactData(identifier);
        if (null != dataset.iconUri) dataset.icon = await _iconAPI.getIcon(dataset.iconUri);
        agentCatalogsResources = await datasetManagement.getAllowedCatalogues(dataset.identifier);
        agentSeriesResources = await datasetManagement.getAllowedSeries(dataset.identifier);

        if (null != dataset.schemaID && DatasetStatus.source == dataset.status) {
          targetDatasetResources = await datasetManagement.getSchemaDatasets(dataset.schemaID);
        }

        itemCountsByConcept = await _dataUploadAPI.getDataItemCounts(identifier);
      }

      WaitMessage().dismiss();
      
      pUpsertDatasetWindow.show(context, dataset, languageResources, licenceResources, themeResources, frequencyResources,
          agentCatalogsResources, peopleResources, organizationResources, agentSeriesResources, existingContactResources, schemaResources,
          currentUserAccount, currentAgent, targetDatasetResources, itemCountsByConcept, preview ?? false);
    });
  }

  @override
  Future<void> contactSourcesChanged(List<String> agentIds) async {
    // TODO - update for tryForApiExceptions
    List<XContactData> agentContacts = await datasetManagement.getMultipleAgentContacts(agentIds);
    pUpsertDatasetWindow.refreshContactResources(agentContacts);
  }

  @override
  Future<void> statusOrSchemaChanged(DatasetStatus status, String? schemaId) async {
    List<XDataset> targetDatasets = [];

    if (null != schemaId && DatasetStatus.source == status)
      targetDatasets = await datasetManagement.getSchemaDatasets(schemaId);

    pUpsertDatasetWindow.refreshTargetDatasetResources(targetDatasets);
    pUpsertDatasetWindow.refreshTargetDatasetId(targetDatasets);
  }

  @override
  Future<void> upsertDataset(BuildContext context, XDataset xDataset, List<XContactData> newContacts, bool isInsert, {bool addApp = false}) async {
    await tryForApiExceptions(context, () async {
      if (isInsert && !await datasetManagement.checkDatasetId(xDataset.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response response = await datasetManagement.upsertDataset(xDataset, newContacts, addApp: addApp);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.datasetUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.datasetError);}

      pUpsertDatasetWindow.refreshIsInsert(code);
      pUpsertDatasetWindow.refreshUserRoles(code);
    });
  }

  @override
  void closeSelected(BuildContext context) {
    pUpsertDatasetWindow.close(context);
  }

  @override
  void pickIconSelected(BuildContext context) async {
    await tryForApiExceptions(context, () async {
      List<XIconData> icons = await _iconAPI.getIconList('');
      List<(XIconData,Uint8List?)> fullIcons = [];
      for (XIconData icon in icons){
        Uint8List? file = await _iconAPI.getIcon(icon.iconUri);
        fullIcons.add((icon,file));
      }

      XIconData? newIcon;
      Uint8List? newIconFile;

      await showIconPickerDialog(context, fullIcons,
        ({required XIconData? icon, iconBytes}) {
          if (null == icon) return;
          newIconFile = iconBytes;
          newIcon = icon;
        }
      );
      if (null != newIcon) {
        if (null == newIcon?.iconUri) {
          newIcon!.iconUri ??= "doorce/${newIcon!.iconName!.toLowerCase().replaceAll(" ", "-")}";
          await _iconAPI.upsertIcon(newIcon!, newIconFile!);
        }
        pUpsertDatasetWindow.refreshIcon(newIcon!.iconUri!, newIconFile!);
      }
    });
  }


  
}
