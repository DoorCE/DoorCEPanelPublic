import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/types/app_status.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MDatasetContentWindow {
  final XDataset dataset;
  final List<XContactData> _datasetContactsResources;
  final List<Language> _languageResources;
  List<XDistribution> _distributionResources;
  final List<Licence> _licenceResources;
  final List<DatasetTheme> _themeResources;
  final List<Frequency> _frequencyResources;
  Map<String, int> conceptSummaries;
  final List<XConcept> concepts;
  final List<XApp> datasetApps;
  XApp? defaultApp;

  String fileErrorString = "";
  XFileData? fileData;

  MDatasetContentWindow(
      this.dataset,
      this._datasetContactsResources,
      this._languageResources,
      this._distributionResources,
      this._licenceResources,
      this._themeResources,
      this._frequencyResources,
      this.conceptSummaries,
      this.concepts,
      this.datasetApps,
      this.defaultApp);

  List<DropdownItem<String>> getLanguageOptions(String? selectedMetadataLanguageCode) {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: language.code == selectedMetadataLanguageCode,
      );
    }).toList();
  }

// -------------------------------------------------------------------------------------------------------- DATASETS --------------------------------------------------------------------------------------------

  XDataset getDataset() {
    return dataset;
  }

  Uint8List? getDatasetIcon() {
    return dataset.icon;
  }

  String getDatasetTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.title[locale] ?? dataset.title["en"] ??
        dataset.title.values.first;
  }

  String? getDatasetSchema() {
    return dataset.schemaTitle;
  }

  List<String> getDatasetSeries(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    List<String>? seriesId = dataset.seriesID;
    return (seriesId.isNotEmpty) ? 
      seriesId
          .map((id) => dataset.seriesTitle[id]![locale] ?? dataset.seriesTitle[id]!["en"] ??
            dataset.seriesTitle[id]!.values.first)
          .toList() 
          : [];
  }

  String getDatasetCatalog(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.catalogueTitle[locale] ?? dataset.catalogueTitle["en"] ??
        dataset.catalogueTitle.values.first;
  }

  List<String> getDatasetTypes(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.type
        .map((typeIndex) =>
            DatasetType.values[typeIndex].getText(context, locale))
        .toList();
  }

  String getDatasetStatus(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.status.getText(context, locale);
  }

  String getDatasetTitleByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return dataset.title[codeLanguage] ??
        dataset.title.values.first;
  }

  String getDatasetDescriptionByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return dataset.description[codeLanguage] ??
        dataset.description.values.first;
  }

  String getDatasetIdentifier() {
    return dataset.identifier;
  }

  String getDatasetVersion() {
    return dataset.version;
  }

  List<String> getDatasetDocumentation() {
    return dataset.documentation;
  }

  List<String> getDatasetProvenance() {
    return dataset.provenance;
  }

  String? getDatasetVersionNotes() {
    return dataset.versionNotes;
  }

  List<String> getDatasetGeographicalCoverage() {
    return dataset.geographicalCoverage;
  }

  String? getDatasetFrequency() {
    return (dataset.frequency != null && dataset.frequency!.isNotEmpty)
        ? _frequencyResources
            .firstWhere((freq) => freq.code == dataset.frequency).label.toString()
        : null;
  }

  List<String> getDatasetTemporalCoverage() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final List<String> temporalCoverage = [];

    for (int i = 0; i < dataset.temporalCoverage.length; i++) {
      final startDate = dataset.temporalCoverage[i].$1;
      final endDate = dataset.temporalCoverage[i].$2;

      temporalCoverage
          .add('${formatter.format(startDate)} --> ${formatter.format(endDate)}');
    }

    return temporalCoverage;
  }

  String? getDataseReleaseDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (null != dataset.releaseDate) return formatter.format(dataset.releaseDate!);
    return null;
  }

  String getDatasetAccessRights(BuildContext context) {
    return AccessRightTypes.values[dataset.accessRights]
        .getText(context, Localizations.localeOf(context).languageCode);
  }

  List<String> getDatasetLanguages() {
    if (dataset.languages.isEmpty) {
      return [];
    }
    return dataset.languages.map((code) {
      return _languageResources.firstWhere((lang) => lang.code == code).name;
    }).toList();
  }

  List<String> getDatasetKeywords() {
    return dataset.keywords;
  }

  List<String> getDatasetApplicableLegislations() {
    return dataset.applicableLegislation;
  }

  List<String> getDatasetLicences() {
    if (dataset.licence.isEmpty) {
      return [];
    }
    return dataset.licence.map((code) {
      return _licenceResources.firstWhere((lic) => lic.code == code).label;
    }).toList();
  }

  List<String> getDatasetThemes() {
    if (dataset.themes.isEmpty) {
      return [];
    }
    return dataset.themes.map((code) {
      return _themeResources.firstWhere((theme) => theme.code == code).label;
    }).toList();
  }

  String? getDatasetRespPerson() {
    return dataset.responsiblePersonName;
  }

  String? getDatasetRespOrganization() {
    return dataset.responsibleOrganisationName;
  }

  List<String> getDatasetEditors() {
    return dataset.editorIDList;
  }

  bool canUserCreateDistributions() {
    return dataset.userRoles.contains(EditorRole.DistributionEditor);
  }

  bool canUploadData() {
    return dataset.status != DatasetStatus.independent;
  }

// -------------------------------------------------------------------------------------------------------- CONTACTS --------------------------------------------------------------------------------------------

  int getContactDataListLenght() {
    return _datasetContactsResources.length;
  }

  XContactData getContactDataResource(int index) {
    return _datasetContactsResources[index];
  }

  (String, String, String?) getContactDataResourceText(int index) {
    XContactData resource = _datasetContactsResources[index];
    return (resource.name, resource.contents, resource.agentName);
  }

// -------------------------------------------------------------------------------------------------------- FILES --------------------------------------------------------------------------------------------

  // **** Data/Files ****

  // Checkers
  bool canUserClearDataItems() {
    return dataset.userRoles.contains(EditorRole.DistributionEditor) && conceptSummaries.isNotEmpty;
  }

  bool canUserPublish() {
    return dataset.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool hasFileToLoad() {
    return null != fileData && ((null != fileData!.content && fileData!.content!.isNotEmpty) || (null != fileData!.downloadUrl && fileData!.downloadUrl!.isNotEmpty));
  }

  bool isFileError() {
    return (fileErrorString.isNotEmpty);
  }

  // Setters
  void setFileSelected(FilePickerResult result) {
    _createFile(result);
  }

  void _createFile(FilePickerResult result) {
    PlatformFile platformFile = result.files.first;
    String? contentType = lookupMimeType(platformFile.name, headerBytes: platformFile.bytes);

    fileData = XFileData(
      fileName: platformFile.name,
      contentType: contentType ?? null,
      content: platformFile.bytes,
      byteSize: platformFile.size);
  }

  void setFileFromUrl(String url) {
    fileData = XFileData(
      downloadUrl: url);
  }

  // Getters
  String? getDataSelectionLabel(BuildContext context) {
    String? fileLabel = fileData?.fileName ?? null;
    String? downloadUrlLabel = fileData?.downloadUrl ?? null;
    return null != fileLabel 
      ? "${AppLocalizations.of(context)!.file}: $fileLabel"
      : null != downloadUrlLabel 
        ? "URL: ${downloadUrlLabel}"
        : null;
  }

  List<String> getConceptUris() {
    return concepts.map((concept) => concept.identifier!).toList();
  }

  // Deletes
  void removeFile() {
      fileData = null;
      fileErrorString = "";
  }


// -------------------------------------------------------------------------------------------------------- DISTRIBUTIONS --------------------------------------------------------------------------------------------

  void refreshDistributionList(List<XDistribution> newResourceList) {
    _distributionResources = newResourceList;
  }
  
  int getDistributionListLenght() {
    return _distributionResources.length;
  }

  XDistribution getDistributionResource(int index) {
    return _distributionResources[index];
  }

  String getDistributionTitle(BuildContext context, int index) {
    String locale = Localizations.localeOf(context).languageCode;
    XDistribution resource = _distributionResources[index];
    return resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
  }

  bool isDistributionEditable(int index) {
    XDistribution resource = _distributionResources[index];
    return resource.isUserEditable;
  }
// -------------------------------------------------------------------------------------------------------- APPS --------------------------------------------------------------------------------------------

  bool areAppsAvailable() {
    return datasetApps.isNotEmpty;
  }

  bool isViewAppButtonEnabled() {
    return datasetApps.any((app) => app.isEnabled == true && app.status == AppStatus.Ready);
  }

  bool isDefaultAppEnabled() {
    if (defaultApp != null) {
      return defaultApp!.isEnabled == true && defaultApp!.status == AppStatus.Ready;
    }
    return false;
  }

  List<XApp> getViewableDatasetApps() {
    return datasetApps.where((app) => app.isEnabled == true && app.status == AppStatus.Ready).toList();
  }

  ViewAppButtonState getViewAppButtonState() {
    final apps = getViewableDatasetApps();
    if (apps.length > 1) {
      if (isDefaultAppEnabled()){
        return ViewAppButtonState.split;
      }
      return ViewAppButtonState.selectedApp;
    }
    return ViewAppButtonState.defaultApp;
  }

}

enum ViewAppButtonState {
  defaultApp,
  selectedApp,
  split,
}