import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MDistributionPreviewWindow {
  final XDistribution _distributionResource;
  final List<Language> _languageResources;
  final Uint8List? _fileContent;
  final bool pathFromMetadataMgmt;

  MDistributionPreviewWindow(
      this._distributionResource, this._languageResources, this._fileContent, this.pathFromMetadataMgmt);

  List<DropdownItem<String>> getLanguageOptions(String? selectedMetadataLanguageCode) {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: language.code == selectedMetadataLanguageCode,
      );
    }).toList();
  }

  Uint8List? getDistributionIcon() {
    return _distributionResource.icon;
  }

  String getDatasetTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return _distributionResource.datasetTitle[locale] ?? _distributionResource.datasetTitle["en"] ??
        _distributionResource.datasetTitle.values.first;
  }

  String getDatasetIdentifier() {
    return _distributionResource.datasetUri;
  }

  String getDistributionTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return _distributionResource.title[locale] ?? _distributionResource.title["en"] ??
        _distributionResource.title.values.first;
  }

  String getDistributionIdentifier() {
    return _distributionResource.identifier;
  }

  String? getDistributionSchema() {
    return _distributionResource.schemaTitle;
  }

  String? getDistributionMaturityStatus() {
    return _distributionResource.status;
  }

  String getDistributionTitleByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return _distributionResource.title[codeLanguage] ??
        _distributionResource.title.values.first;
  }

  String getDistibutionDescriptionByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return _distributionResource.description[codeLanguage] ??
        _distributionResource.description.values.first;
  }

  String getDatasetTitleByCodeLanguage(
      BuildContext context, String codeLanguage) {
    if (_distributionResource.datasetTitle.isEmpty) {
      return "";
    }
    return _distributionResource.datasetTitle[codeLanguage] ??
        _distributionResource.datasetTitle.values.first;
  }

  String getServiceTitleByCodeLanguage(
      BuildContext context, String codeLanguage) {
    if (_distributionResource.dataServiceTitle.isEmpty) {
      return "";
    }
    return _distributionResource.dataServiceTitle[codeLanguage] ??
        _distributionResource.dataServiceTitle.values.first;
  }

  String getDistributionDownloadUrl() {
    return _distributionResource.downloadUrl ?? "";
  }

  List<String> getDistributionAccessUrls() {
    if (_distributionResource.accessUrl.isEmpty) {
      return [];
    }
    return _distributionResource.accessUrl;
  }

  String? getDistributionFormat() {
    return _distributionResource.format;
  }

  String? getDistributionMediaType() {
    return _distributionResource.mediaType;
  }

  String getDistributionAccessRights(BuildContext context) {
    return AccessRightTypes.values[_distributionResource.accessStatus]
        .getText(context, Localizations.localeOf(context).languageCode);
  }

  List<String> getDistributionLanguages() {
    if (_distributionResource.languages.isEmpty) {
      return [];
    }
    return _distributionResource.languages.map((code) {
      return _languageResources.firstWhere((lang) => lang.code == code).name;
    }).toList();
  }

  String? getDistributionReleaseDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (null != _distributionResource.releaseDate) return formatter.format(_distributionResource.releaseDate!);
    return null;
  }

  String getDistributionByteSize() {
    return _distributionResource.byteSize.toString();
  }

  Uint8List? getDistributionFileContent() {
    return _fileContent;
  }

  String? getDistributionFileName() {
    return _distributionResource.fileName;
  }

  String getServiceIdentifier() {
    return _distributionResource.dataServiceUri ?? "";
  }

  String getServiceTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return _distributionResource.dataServiceTitle[locale] ?? _distributionResource.dataServiceTitle["en"] ??
        _distributionResource.dataServiceTitle.values.first;
  }
}