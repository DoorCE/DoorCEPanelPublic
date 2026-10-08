import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_status.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/common.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MCataloguesWindow {
  final XCatalogue _currentCatalogResources;
  late List<XOwnableResource> catalogResources;
  late List<XOwnableResource> datasetsResources;
  late List<XOwnableResource> seriesResources;
  late List<XOwnableResource> servicesResources;
  late List<XPerson> persons;
  late List<XOrganization> organisations;

  MCataloguesWindow(this.catalogResources, this.datasetsResources,
      this.seriesResources, this.servicesResources, this._currentCatalogResources, this.persons, this.organisations);

  void refreshResourceList(List<XOwnableResource> newResourceList) {
    if ((newResourceList.runtimeType == List<XDataset>) || (newResourceList.isNotEmpty && newResourceList.first is XDataset)) {
      datasetsResources = newResourceList;
    } else if ((newResourceList.runtimeType == List<XDatasetSeries>) || (newResourceList.isNotEmpty && newResourceList.first is XDatasetSeries)) {
      seriesResources = newResourceList;
    } else if ((newResourceList.runtimeType == List<XCatalogue>) || (newResourceList.isNotEmpty && newResourceList.first is XCatalogue)) {
      catalogResources = newResourceList;
    } else if ((newResourceList.runtimeType == List<XDatasetService>) || (newResourceList.isNotEmpty && newResourceList.first is XDatasetService)) {
      servicesResources = newResourceList;
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

  // void initPageState(BuildContext context) {
  //   state = context.read<AppRouterDelegate>().currentState;
  //   if (state == null) {
  //     state = PageState.fromTypes([XCatalogue, XDataset, XDatasetSeries, XDatasetService]);
  //   }
  // }

  ParameterizedListController<T> setController<T>(BuildContext context) {
    return ParameterizedListController<T>(
      querySet: _getQueryset<T>() as List<T>,
      filterSet: getFilterSet<T>(context),
      queryParams: QueryParams(filters: {}));
      // queryParams: state!.getByType<T>() ?? (throw Exception("PageState is null — cannot get query params for type $T")));
  }

  List<XOwnableResource> _getQueryset<T>() {
    switch (T) {
      case XCatalogue:
        return catalogResources;
      case XDataset:
        return datasetsResources;
      case XDatasetSeries:
        return seriesResources;
      case XDatasetService:
        return servicesResources;
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
      case XDatasetService:
        filters = generateServiceFilters(context);
        break;
      default:
        break;
    }

    filters = [...filters, ..._getCommonFilters<T>(context)];

    return FilterSet(filters);
  }

  // TODO - build widget only if there are options?
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
      BoolFilter<XOwnableResource, bool>(
        fieldName: "userRoles", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XOwnableResource item) => item.userRoles.contains(EditorRole.MetadataEditor)
         || item.userRoles.contains(EditorRole.OwnershipEditor)
      ),
    ];
  }

  // -------------------------------------------------------------------------------------------------------- PARENT CATALOGUE --------------------------------------------------------------------------------------------

  XCatalogue getCurrentCatalog() {
    return _currentCatalogResources;
  }

  String getParentCatalogTitle(BuildContext context) {
    if (_currentCatalogResources.parentTitle.isNotEmpty) {
      return _currentCatalogResources.parentTitle[Localizations.localeOf(context).languageCode] ??
          _currentCatalogResources.parentTitle["en"] ??
          _currentCatalogResources.parentTitle.values.first;
    }
    return ""; // Valore di default se non ci sono titoli
  }

  String? getParentCatalogIdentifier() {
    return _currentCatalogResources.parentID;
  }

  String getCurrentCatalogTitle(BuildContext context) {
    return _currentCatalogResources.title[Localizations.localeOf(context).languageCode]??
        _currentCatalogResources.title["en"]??
        _currentCatalogResources.title.values.first;
  }

  String getCurrentCatalogIdentifier(){
    return _currentCatalogResources.identifier;
  }

  bool isUserMetadataEditor() {
    return _currentCatalogResources.userRoles.contains(EditorRole.MetadataEditor);
  }

// -------------------------------------------------------------------------------------------------------- CATALOGUE --------------------------------------------------------------------------------------------

  int getCatalogResourceListLength() {
    return catalogResources.length;
  }

  XCatalogue getCatalogResource(int index) {
    return catalogResources[index] as XCatalogue;
  }

  String getCatalogResourceIdentifier(int index) {
    return catalogResources[index].identifier;
  }

  Uint8List? getCatalogResourceIcon(XCatalogue cat) {
    return cat.icon;
  }

  bool isCatalogueEditable(XCatalogue catalogue) {
    return catalogue.userRoles.contains(EditorRole.MetadataEditor) 
      || catalogue.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isCatalogueDeletable(XCatalogue catalogue) {
    return catalogue.userRoles.contains(EditorRole.MetadataEditor);
  }

// -------------------------------------------------------------------------------------------------------- DATASETS --------------------------------------------------------------------------------------------

  int getDatasetResourceListLength() {
    return datasetsResources.length;
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
    return datasetsResources[index].identifier;
  }

  XDataset getDatasetResource(int index) {
    return datasetsResources[index] as XDataset;
  }

  Uint8List? getDatasetResourceIcon(int index) {
    return datasetsResources[index].icon;
  }

  bool isDatasetEditable(XDataset resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor) 
      || resource.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool _isDatasetUserMetadataEditor(XDataset resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isDatasetDeletable(XDataset dataset) {
    return _isDatasetUserMetadataEditor(dataset);
  }

  bool isDatasetPublishable(XDataset dataset) {
    return _isDatasetUserMetadataEditor(dataset);
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

        var seriesOptions = seriesResources.map((s) 
          => FilterOption(
            label: getResourceTitle(context, s), 
            value: s.identifier)).toList();

        Map<String, String> schemas = Map.fromIterable(datasetsResources,
          key: (d) => (d as XDataset).schemaID ?? "",
          value: (d) => (d as XDataset).schemaTitle ?? ""
          );

        var schemaOptions = FilteringCommon.generateFilterOptionsFromMap(schemas);

        Set<String> provenances = Set();
        for (var dat in datasetsResources) {
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
    return seriesResources.length;
  }

  String getSeriesResourceIdentifier(int index) {
    return seriesResources[index].identifier;
  }

  Uint8List? getSeriesResourceIcon(XDatasetSeries series) {
    return series.icon;
  }

  XDatasetSeries getSeriesResource(int index) {
    return seriesResources[index] as XDatasetSeries;
  }

  bool isSeriesEditable(XDatasetSeries resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor) 
      || resource.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isSeriesDeletable(XDatasetSeries resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor);
  }

// -------------------------------------------------------------------------------------------------------- SERVICES --------------------------------------------------------------------------------------------

  int getServicesResourceListLength() {
    return servicesResources.length;
  }

  XDatasetService getServicesResource(int index) {
    return servicesResources[index] as XDatasetService;
  }

  String getServicesResourceIdentifier(int index) {
    return servicesResources[index].identifier;
  }

  Uint8List? getServicesResourceIcon(XDatasetService service) {
    return service.icon;
  }

  bool isServiceEditable(XDatasetService resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor) 
      || resource.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isServiceDeletable(XDatasetService resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor);
  }

  List<FilterDefinition> generateServiceFilters(BuildContext context) {
    var serviceStatusOptions = AccessStatus.values.map((s) 
            => FilterOption(
              label: s.getText(context, Localizations.localeOf(context).languageCode), 
              value: s.index)).toList();

          Set<String> formats = Set(); 
          for (var ser in servicesResources) {
            ser as XDatasetService;
            formats.addAll(ser.format);
          }

          var formatOptions = FilteringCommon.generateFilterOptionsFromIterable(formats);

        return [
            EnumFilter<XDatasetService, int>(
              fieldName: "status", 
              label: AppLocalizations.of(context)!.statusField, 
              filterOptions: serviceStatusOptions, 
              filterTarget: (XDatasetService item) => item.status
              ),
            EnumFilter<XDatasetService, String>(
              fieldName: "format",
              label: AppLocalizations.of(context)!.formats, 
              filterOptions: formatOptions ?? [], 
              filterTarget: (XDatasetService item) => item.format,
              modeOptionsEnabled: true
              )
          ];
  }

}