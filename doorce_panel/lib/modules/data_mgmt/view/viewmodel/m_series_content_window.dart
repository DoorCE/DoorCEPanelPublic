import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MSeriesContentWindow {
  final XDatasetSeries series;
  final List<XContactData> _seriesContactsResources;
  final List<Language> _languageResources;
  List<XDataset> _datasetResources;
  final List<Licence> _licenceResources;
  final List<DatasetTheme> _themeResources;
  final List<Frequency> _frequencyResources;

  MSeriesContentWindow(
      this.series,
      this._seriesContactsResources,
      this._languageResources,
      this._datasetResources,
      this._licenceResources,
      this._themeResources,
      this._frequencyResources);

  List<DropdownItem<String>> getLanguageOptions(String? selectedMetadataLanguageCode) {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: language.code == selectedMetadataLanguageCode,
      );
    }).toList();
  }

// -------------------------------------------------------------------------------------------------------- DATASET SERIES --------------------------------------------------------------------------------------------

  XDatasetSeries getSeries() {
    return series;
  }

  Uint8List? getSeriesIcon() {
    return series.icon;
  }

  String getSeriesTitle(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return series.title[locale] ?? series.title["en"] ??
        series.title.values.first;
  }

  String getSeriesCatalog(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;
    return series.catalogueTitle[locale] ?? series.catalogueTitle["en"] ??
        series.catalogueTitle.values.first;
  }

  String getSeriesTitleByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return series.title[codeLanguage] ??
        series.title.values.first;
  }

  String getSeriesDescriptionByCodeLanguage(
      BuildContext context, String codeLanguage) {
    return series.description[codeLanguage] ??
        series.description.values.first;
  }

  String getSeriesIdentifier() {
    return series.identifier;
  }

  List<String> getSeriesGeographicalCoverage() {
    return series.geographicalCoverage;
  }

  String? getSeriesFrequency() {
    return (series.frequency != null && series.frequency!.isNotEmpty)
        ? _frequencyResources
            .firstWhere((freq) => freq.code == series.frequency).label
        : null;
  }

  List<String> getSeriesTemporalCoverage() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final List<String> temporalCoverage = [];

    for (int i = 0; i < series.temporalCoverage.length; i++) {
      final startDate = series.temporalCoverage[i].$1;
      final endDate = series.temporalCoverage[i].$2;

      temporalCoverage
          .add('${formatter.format(startDate)} --> ${formatter.format(endDate)}');
    }

    return temporalCoverage;
  }

  String? getSeriesReleaseDate() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    if (null != series.releaseDate) return formatter.format(series.releaseDate!);
    return null;
  }

  String getSeriesAccessRights(BuildContext context) {
    return AccessRightTypes.values[series.accessRights]
        .getText(context, Localizations.localeOf(context).languageCode);
  }

  List<String> getSeriesLanguages() {
    if (series.languages.isEmpty) {
      return [];
    }
    return series.languages.map((code) {
      return _languageResources.firstWhere((lang) => lang.code == code).name;
    }).toList();
  }

  List<String> getSeriesKeywords() {
    return series.keywords;
  }

  List<String> getSeriesApplicableLegislations() {
    return series.applicableLegislation;
  }

  List<String> getSeriesLicences() {
    if (series.licence.isEmpty) {
      return [];
    }
    return series.licence.map((code) {
      return _licenceResources.firstWhere((lic) => lic.code == code).label;
    }).toList();
  }

  List<String> getSeriesThemes() {
    if (series.themes.isEmpty) {
      return [];
    }
    return series.themes.map((code) {
      return _themeResources.firstWhere((theme) => theme.code == code).label;
    }).toList();
  }

  String? getSeriesRespPerson() {
    return series.responsiblePersonName;
  }

  String? getSeriesRespOrganization() {
    return series.responsibleOrganisationName;
  }

  List<String> getSeriesEditors() {
    return series.editorIDList;
  }

// -------------------------------------------------------------------------------------------------------- CONTACTS --------------------------------------------------------------------------------------------

  int getContactDataListLenght() {
    return _seriesContactsResources.length;
  }

  XContactData getContactDataResource(int index) {
    return _seriesContactsResources[index];
  }

// -------------------------------------------------------------------------------------------------------- DATASETS --------------------------------------------------------------------------------------------

  void refreshDatasetList(List<XDataset> newResourceList) {
    _datasetResources = newResourceList;
  }
  
  int getDatasetListLenght() {
    return _datasetResources.length;
  }

  XDataset getDatasetResource(int index) {
    return _datasetResources[index];
  }

  String getDatasetTitle(BuildContext context, int index) {
    String locale = Localizations.localeOf(context).languageCode;
    XDataset resource = _datasetResources[index];
    return resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
  }

  bool isDatasetEditable(XDataset dataset) {
    return dataset.userRoles.contains(EditorRole.MetadataEditor) ||
      dataset.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isDatasetDeletable(XDataset dataset) {
    return dataset.userRoles.contains(EditorRole.MetadataEditor);
  }
}
