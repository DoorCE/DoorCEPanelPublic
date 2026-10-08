import 'dart:typed_data';

import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/common.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MDataManagementWindow {
  late List<XOwnableResource> _datasetsResources;
  late List<XOwnableResource> _seriesResources;
  late List<XPerson> persons;
  late List<XOrganization> organisations;

  MDataManagementWindow(this._datasetsResources, this._seriesResources, this.persons, this.organisations);

  void refreshResourceList(List<XOwnableResource> newResourceList) {
    if (newResourceList.first is XDataset) {
      _datasetsResources = newResourceList;
    } else if (newResourceList.first is XDatasetSeries) {
      _seriesResources = newResourceList;
    } else {
      throw Exception("Unsupported resource type");
    }
  }

  String getResourceTitle(BuildContext context, XOwnableResource resource) {
    String locale = Localizations.localeOf(context).languageCode;
    return resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
  }

  String getResourceDescription(BuildContext context, XOwnableResource resource) {
    String locale = Localizations.localeOf(context).languageCode;
    return resource.description[locale] ?? resource.description["en"] ?? resource.description.values.first;
  }

  // -------------------------------------------------------------------------------------------------------- FILTERING --------------------------------------------------------------------------------------------

  ParameterizedListController<T> setController<T>(BuildContext context) {
    return ParameterizedListController<T>(
      querySet: _getQueryset<T>() as List<T>,
      filterSet: getFilterSet<T>(context),
      queryParams: QueryParams(filters: {}));
      // queryParams: state!.getByType<T>() ?? (throw Exception("PageState is null — cannot get query params for type $T")));
  }

  List<Object> _getQueryset<T>() {
    switch (T) {
      case XDataset:
        return _datasetsResources;
      case XDatasetSeries:
        return _seriesResources;
      default:
        throw Exception("Unsupported resource type");
    }
  }

  FilterSet<T> getFilterSet<T>(BuildContext context) {
    List<FilterDefinition> filters = [];

    switch (T) {
      case XDataset:
        filters = generateDatasetFilters(context);
        break;
      default:
        break;
    }

    filters = [...filters, ..._getCommonFilters<T>(context)];

    return FilterSet(filters);
  }

  List<FilterDefinition<XOwnableResource, Object>> _getCommonFilters<T>(BuildContext context) {
    List<FilterOption>? personOptions = persons.map((p)
      => FilterOption(
        label: p.fullName, 
        value: p.identifier)).toList();

    List<FilterOption>? organisationOptions = organisations.map((o) 
      => FilterOption(
        label: o.name,
        value: o.identifier)).toList();

    return [
      EnumFilter<XOwnableResource, String>(
          fieldName: "responsiblePersonID", 
          label: AppLocalizations.of(context)!.responsiblePerson, 
          filterOptions: personOptions, 
          filterTarget: (XOwnableResource item) => item.responsiblePersonID
        ),
      EnumFilter<XOwnableResource, String>(
          fieldName: "responsibleOrganisationID", 
          label: AppLocalizations.of(context)!.responsibleOrganization, 
          filterOptions: organisationOptions, 
          filterTarget: (XOwnableResource item) => item.responsibleOrganisationID),
    ];
  }

// -------------------------------------------------------------------------------------------------------- DATASETS --------------------------------------------------------------------------------------------

  bool canPublishData(XDataset resource) {
    return resource.schemaID != null && resource.schemaID!.isNotEmpty && resource.status != DatasetStatus.independent;
  }

  bool isDatasetUserMetadataEditor(XDataset resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor);
  }

  int getDatasetResourceListLength() {
    return _datasetsResources.length;
  }

  XDataset getDatasetResource(int index) {
    return _datasetsResources[index] as XDataset;
  }

  String getDatasetAttributesSummary(BuildContext context, XDataset dataset) {
    String locale = Localizations.localeOf(context).languageCode;
    String types = dataset.type
        .map((typeIndex) => DatasetType.values[typeIndex].getText(context, locale))
        .join(", ");
    return "${AppLocalizations.of(context)!.schema}: ${dataset.schemaTitle} | ${AppLocalizations.of(context)!.type}: $types | ${AppLocalizations.of(context)!.status}: ${dataset.status.getText(context, locale)}";
  }

  List<String> getDatasetSeriesTitles(BuildContext context, XDataset dataset) {
    String locale = Localizations.localeOf(context).languageCode;
    return dataset.seriesTitle.entries
        .map((entry) => entry.value[locale] ?? entry.value["en"] ?? entry.value.values.first).toList();
  }

  String getDatasetResourceIdentifier(int index) {
    return _datasetsResources[index].identifier;
  }

  Uint8List? getDatasetResourceIcon(XDataset dataset) {
    return dataset.icon;
  }

  List<FilterDefinition> generateDatasetFilters(BuildContext context) {
    List<FilterOption> typeOptions = DatasetType.values.map((v) 
          => FilterOption(
              label: v.getText(context, Localizations.localeOf(context).languageCode),
              value: v.index)).toList();
        
        List<FilterOption> statusOptions = DatasetStatus.values.map((v)
          => FilterOption(
            label: v.getText(context, Localizations.localeOf(context).languageCode), 
            value: v.index)).toList();

        var seriesOptions = _seriesResources.map((s) 
          => FilterOption(
            label: getResourceTitle(context, s), 
            value: s.identifier)).toList();

        Map<String, String> schemas = Map.fromIterable(_datasetsResources,
          key: (d) => (d as XDataset).schemaID ?? "",
          value: (d) => (d as XDataset).schemaTitle ?? ""
          );

        var schemaOptions = FilteringCommon.generateFilterOptionsFromMap(schemas);

        Set<String> provenances = Set();
        for (var dat in _datasetsResources) {
          dat as XDataset;
          provenances.addAll(dat.provenance);
        }

        var provenanceOptions = FilteringCommon.generateFilterOptionsFromIterable(provenances);

      return [
          EnumFilter<XDataset, int>(
            fieldName: "type", 
            label: AppLocalizations.of(context)!.typesField, 
            filterOptions: typeOptions, 
            filterTarget: (XDataset item) => item.type,
            modeOptionsEnabled: true
            ),
          EnumFilter<XDataset, int>(
            fieldName: "status", 
            label: AppLocalizations.of(context)!.statusField, 
            filterOptions: statusOptions, 
            filterTarget: (XDataset item) => item.status.index
            ),
          EnumFilter<XDataset, String>(
            fieldName: "seriesID", 
            label: AppLocalizations.of(context)!.series, 
            filterOptions: seriesOptions, 
            filterTarget: (XDataset item) => item.seriesID,
            modeOptionsEnabled: true
            ),
          EnumFilter<XDataset, String>(
            fieldName: "schemaID", 
            label: AppLocalizations.of(context)!.schema, 
            filterOptions: schemaOptions ?? [], 
            filterTarget: (XDataset item) => item.schemaID
            ),
          EnumFilter<XDataset, String>(
            fieldName: "provenance", 
            label: AppLocalizations.of(context)!.provenance, 
            filterOptions: provenanceOptions ?? [], 
            filterTarget: (XDataset item) => item.provenance,
            modeOptionsEnabled: true
            )
        ];
  }  

// -------------------------------------------------------------------------------------------------------- SERIES --------------------------------------------------------------------------------------------

  int getSeriesResourceListLength() {
    return _seriesResources.length;
  }

  XDatasetSeries getSeriesResource(int index) {
    return _seriesResources[index] as XDatasetSeries;
  }

  (String, String) getSeriesResourceTexts(BuildContext context, XDatasetSeries resource) {

    String locale = Localizations.localeOf(context).languageCode;
    String title = resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
    String descr =
        resource.description[locale] ?? resource.description["en"] ?? resource.description.values.first;

    return (title, descr);
  }

  String getSeriesResourceIdentifier(int index) {
    return _seriesResources[index].identifier;
  }

  Uint8List? getSeriesResourceIcon(XDatasetSeries series) {
    return series.icon;
  }
}
