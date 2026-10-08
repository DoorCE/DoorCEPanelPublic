import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/maturity_status.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class MUpsertDistributionWindow {
  late XDataset dataset;
  late XDistribution distribution;
  final List<Language> _languageResources;
  final List<String> _formatResources;
  final List<String> _mediaTypeResources;
  late List<XDataset> _agentDatasetResources;
  late List<XDatasetService> _agentServiceResources;
  final List<MaturityStatus> _maturityStatusResources;
  late XFileData? fileData;
  late List<XDataSchema> _schemaResources;

  late bool isInsert;

  MUpsertDistributionWindow(
    this._languageResources,
    this._formatResources,
    this._mediaTypeResources,
    this._maturityStatusResources,
  );

  void init(
      XDataset dataset,
      XDistribution distribution,
      List<XDataset> agentDatasetResources,
      List<XDatasetService> agentServiceResources,
      XFileData? fileData,
      List<XDataSchema> schemaResources) {
    this.dataset = dataset;
    this.distribution = distribution;
    this._agentDatasetResources = agentDatasetResources;
    this._agentServiceResources = agentServiceResources;
    this.fileData = fileData;
    this._schemaResources = schemaResources;
  }

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = distribution.identifier.isEmpty;
  }

  // **** Data/Files ****

  bool hasFile() {
    return null != fileData || (null != distribution.downloadUrl && distribution.downloadUrl!.isNotEmpty);
  }

  // Getters
  String? getDataSelectionLabel(BuildContext context) {
    String? fileLabel = fileData?.fileName ?? null;
    String? downloadUrl = distribution.downloadUrl;
    return null != fileLabel 
      ? "${AppLocalizations.of(context)!.file}: $fileLabel"
      : null != downloadUrl 
        ? "URL: ${distribution.downloadUrl}"
        : null;
  }
  
  // Setters
  void setFileSelected(FilePickerResult result) {
    _createFile(result);
    _linkNewFileToDistribution(result);
  }

  void _createFile(FilePickerResult result) {
    PlatformFile platformFile = result.files.first;
    String? contentType = lookupMimeType(platformFile.name, headerBytes: platformFile.bytes);

    fileData = XFileData(
      fileName: platformFile.name,
      contentType: contentType,
      content: platformFile.bytes);
  }

  void _linkNewFileToDistribution(FilePickerResult result) {
    distribution.fileName = fileData!.fileName;
    distribution.byteSize = result.files.first.size;
  }

  // Deletes
  void removeFileFromDistribution() {
    distribution.fileId = null;
    distribution.fileName = null;
    distribution.byteSize = 0;
  }

  void removeFile() {
      fileData = null;
      distribution.downloadUrl = null;
      removeFileFromDistribution();
  }

  // **** Distribution methods ****

  // Setters
  void updateDistributionReleaseDate([DateTime? releaseDate]) {
    if (releaseDate != null) {
      distribution.releaseDate = releaseDate;
    } else {
      distribution.releaseDate = DateTime.now();
    }
  }

  // Empty checks
  bool isDistributionTitlesEmpty() {
    return distribution.title.isEmpty ||
        distribution.title.values.every((title) => title.isEmpty);
  }

  bool isDistributionDescriptionsEmpty() {
    return distribution.description.isEmpty ||
        distribution.description.values.every((description) => description.isEmpty);
  }

  // Identifiers
  String createDistributionIdentifier(String title){
    return MUriGenerator.generateUriFromResource(distribution, title);
  }

  // **** Dataset ****
  
  String getDatasetTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.title[locale] ?? dataset.title["en"] ??
        dataset.title.values.first;
  }

  // **** Options for dropdowns ****

  List<DropdownItem<AccessRightTypes>> getAccessRightOptions(
      BuildContext context) {
    return AccessRightTypes.values.map((accessRight) {
      return DropdownItem<AccessRightTypes>(
        value: accessRight,
        label: accessRight.getText(
            context, Localizations.localeOf(context).toString()),
        selected: distribution.accessStatus == accessRight.index
      );
    }).toList();
  }

  List<DropdownItem<String>> getDatasetOptions(BuildContext context) {
    return _agentDatasetResources.map((datasetOption) {
      return DropdownItem<String>(
        value: datasetOption.identifier,
        label: datasetOption.title[Localizations.localeOf(context).languageCode] ??
            datasetOption.title["en"] ??
            datasetOption.title.values.first,
        selected: dataset.identifier == datasetOption.identifier
      );
    }).toList();
  }

  List<DropdownItem<String>> getServicesOptions(BuildContext context) {
    return _agentServiceResources.map((service) {
      return DropdownItem<String>(
        value: service.identifier,
        label: service.title[Localizations.localeOf(context).languageCode] ??
            service.title["en"] ??
            service.title.values.first,
        selected: distribution.dataServiceUri == service.identifier
      );
    }).toList();
  }

  List<DropdownItem<String>> getMediaType() {
    return _mediaTypeResources.map((mediaType) {
      return DropdownItem<String>(
        value: mediaType,
        label: mediaType,
        selected: distribution.mediaType == mediaType
      );
    }).toList();
  }

  List<DropdownItem<String>> getMetadataLanguageOptions(String? selectedMetadataLanguageCode) {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: language.code == selectedMetadataLanguageCode
      );
    }).toList();
  }

  List<DropdownItem<String>> getLanguageOptions() {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: distribution.languages.contains(language.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getMaturityStatusOptions() {
    return _maturityStatusResources.map((status) {
      return DropdownItem<String>(
        value: status.code,
        label: status.label,
        selected: distribution.status == status.code
      );
    }).toList();
  }

  List<DropdownItem<String>> getFormatOptions() {
    return _formatResources.map((format) {
      return DropdownItem<String>(
        value: format,
        label: format,
        selected: distribution.format == format
      );
    }).toList();
  }

  List<DropdownItem<XDataSchema>> getSchemaOptions() {
    return _schemaResources.map((schema) {
      return DropdownItem<XDataSchema>(
        value: schema,
        label: "${schema.seriesTitle}: ${schema.title}",
        selected: distribution.schemaUri == schema.identifier
      );
    }).toList();
  }
}