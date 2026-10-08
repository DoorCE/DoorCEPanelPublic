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

class MOpenSeriesWindow {
  final List<XDataset> _seriesContentResources;
  final XDatasetSeries _series;
  final List<XPerson> persons;
  final List<XOrganization> organizations;

  MOpenSeriesWindow(this._seriesContentResources, this._series, this.persons, this.organizations);

// -------------------------------------------------------------------------------------------------------- FILTERING --------------------------------------------------------------------------------------------

  // void initPageState(BuildContext context) {
  //   state = context.read<AppRouterDelegate>().currentState;
  //   if (state == null) {
  //     state = PageState.fromTypes([XCatalogue, XDataset, XDatasetSeries, XDatasetService]);
  //   }
  // }

  ParameterizedListController<XDataset> setController(BuildContext context) {
    return ParameterizedListController<XDataset>(
      querySet: _seriesContentResources,
      filterSet: getFilterSet(context),
      queryParams: QueryParams(filters: {}));
      // queryParams: state!.getByType<T>() ?? (throw Exception("PageState is null — cannot get query params for type $T")));
  }

  FilterSet<XDataset> getFilterSet(BuildContext context) {
    List<FilterDefinition> filters = [];
    filters = generateDatasetFilters(context);

    filters = [...filters, ..._getCommonFilters(context)];

    return FilterSet<XDataset>(filters);
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

        Map<String, String> schemas = Map.fromIterable(_seriesContentResources,
          key: (d) => (d as XDataset).schemaID ?? "",
          value: (d) => (d as XDataset).schemaTitle ?? ""
          );

        var schemaOptions = FilteringCommon.generateFilterOptionsFromMap(schemas);

        Set<String> provenances = Set();
        for (var dat in _seriesContentResources) {
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

  List<FilterDefinition<XDataset, Object>> _getCommonFilters(BuildContext context) {
    List<FilterOption>? personOptions = persons.map((p)
      => FilterOption(
        label: p.fullName, 
        value: p.identifier)).toList();

    List<FilterOption>? organisationOptions = organizations.map((o) 
      => FilterOption(
        label: o.name,
        value: o.identifier)).toList();

    return [
      EnumFilter<XDataset, String>(
          fieldName: "responsiblePersonID", 
          label: AppLocalizations.of(context)!.responsiblePerson, 
          filterOptions: personOptions, 
          filterTarget: (XOwnableResource item) => item.responsiblePersonID
        ),
      EnumFilter<XDataset, String>(
          fieldName: "responsibleOrganisationID", 
          label: AppLocalizations.of(context)!.responsibleOrganization, 
          filterOptions: organisationOptions, 
          filterTarget: (XOwnableResource item) => item.responsibleOrganisationID),
      BoolFilter<XDataset, bool>(
        fieldName: "userRoles", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XOwnableResource item) => item.userRoles.contains(EditorRole.MetadataEditor)
         || item.userRoles.contains(EditorRole.OwnershipEditor)
      ),
    ];
  }

// **** Series ***********************************************************************

  String getSeriesTitle(BuildContext context) {
    return _series.title[Localizations.localeOf(context).languageCode]??
        _series.title["en"] ??
        _series.title.values.first;
  }

  // **** Dataset resources *******************************************************

  int getDatasetResourceListLength() {
    return _seriesContentResources.length;
  }

  String getDatasetResourceTitle(BuildContext context, XDataset resource) {
    String locale = Localizations.localeOf(context).languageCode;
    return resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
  }

  String getDatasetResourceDescription(BuildContext context, XDataset resource) {
    String locale = Localizations.localeOf(context).languageCode;
    return resource.description[locale] ?? resource.description["en"] ?? resource.description.values.first;
  }

  String getDatasetResourceParams(BuildContext context, XDataset resource) {
    String locale = Localizations.localeOf(context).languageCode;
    if (resource is XDataset) {
      XDataset dat = resource;
      String types = dat.type
          .map((typeIndex) =>
              DatasetType.values[typeIndex].getText(context, locale))
          .join(", ");
      return "${AppLocalizations.of(context)!.schema}: ${dat.schemaTitle} | ${AppLocalizations.of(context)!.type}: $types | ${AppLocalizations.of(context)!.status}: ${dat.status.getText(context, locale)}";
    }
    return "";
  }

  List<String> getDatasetResourceSeries(BuildContext context, XDataset resource) {
    String locale = Localizations.localeOf(context).languageCode;
    if (resource is XDataset) {
      XDataset dat = resource;
      return dat.seriesTitle.entries
          .map((t) => t.value[locale] ?? t.value["en"] ?? t.value.values.first)
          .toList();
    }
    return [];
  }

  String getDatasetResourceIdentifier(XDataset resource) {
    return resource.identifier;
  }

  Uint8List? getDatasetResourceIcon(XDataset resource) {
    return resource.icon;
  }

  String? getCatalogueId() {
    return _series.catalogueID;
  }

  String getSeriesId() {
    return _series.identifier;
  }

  bool isDatasetEditable(XDataset resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor) 
      || resource.userRoles.contains(EditorRole.OwnershipEditor);
  }
}
