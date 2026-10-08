import 'package:doorce_panel/common/types/app_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/common.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MSchemaManagementWindow {
  late List<XDataSchema> schemaResources;
  late List<XSchemaSeries> seriesResources;
  late List<XApp> apps;
  late List<XAppTemplate> appTemplates;
  late XUserAccount currentAccount;

  MSchemaManagementWindow(this.schemaResources, this.seriesResources, this.apps, this.appTemplates, this.currentAccount);

  void refreshResourceList(List<XIdentifiableElement> newResourceList) {
    if (newResourceList.first is XDataSchema) {
      schemaResources = newResourceList as List<XDataSchema>;
    } else if (newResourceList.first is XSchemaSeries) {
      seriesResources = newResourceList as List<XSchemaSeries>;
    } else if (newResourceList.first is XApp) {
      apps = newResourceList as List<XApp>;
    } else if (newResourceList.first is XAppTemplate) {
      appTemplates = newResourceList as List<XAppTemplate>;
    } else {
      throw Exception("Unsupported resource type");
    }
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
      case XDataSchema:
        return schemaResources;
      case XSchemaSeries:
        return seriesResources;
      case XApp:
        return apps;
      case XAppTemplate:
        return appTemplates;
      default:
        throw Exception("Unsupported resource type");
    }
  }

  FilterSet<T> getFilterSet<T>(BuildContext context) {
    List<FilterDefinition> filters = [];

    switch (T) {
      case XDataSchema:
        filters = generateSchemaFilters(context);
        break;
      case XSchemaSeries:
        filters = generateSeriesFilters(context);
        break;
      case XApp:
        filters = generateAppFilters(context);
        break;
      case XAppTemplate:
        filters = generateTemplateFilters(context);
        break;
      default:
        break;
    }
    return FilterSet(filters);
  }

// -------------------------------------------------------------------------------------------------------- SCHEMAS --------------------------------------------------------------------------------------------

  int getDataSchemaResourceListLength() {
    return schemaResources.length;
  }

  XDataSchema getDataSchemaResource(int index) {
    return schemaResources[index];
  }

  String getDataSchemaResourceIdentifier(XDataSchema resource) {
    return resource.identifier;
  }

  bool isSchemaEditable(XDataSchema resource) {
    return resource.isUserEditable;
  }

  List<FilterDefinition> generateSchemaFilters(BuildContext context) {
    var seriesOptions = seriesResources.map((o)
      => FilterOption(label: o.title, value: o.identifier)).toList();
    
    return [
      EnumFilter<XDataSchema, String>(
        fieldName: "seriesIdentifier", 
        label: AppLocalizations.of(context)!.series, 
        filterOptions: seriesOptions,
        filterTarget: (XDataSchema item) => item.seriesIdentifier),
      BoolFilter<XDataSchema, bool>(
        fieldName: "isUserEditable", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XDataSchema item) => item.isUserEditable)
    ];
  }

// -------------------------------------------------------------------------------------------------------- SERIES --------------------------------------------------------------------------------------------

  int getSeriesResourceListLength() {
    return seriesResources.length;
  }

  XSchemaSeries getSeriesResource(int index) {
    return seriesResources[index];
  }

  String getSeriesResourceIdentifier(XSchemaSeries resource) {
    return resource.identifier;
  }

  bool canAddSeries() {
    return currentAccount.roles.contains(GlobalRole.SchemaCreator);
  }

  bool isSeriesEditable(XSchemaSeries resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor) 
      || resource.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isSeriesDeletable(XSchemaSeries resource) {
    return resource.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isAnySeriesMetadataEditable() {
    return seriesResources.any((series) => series.userRoles.contains(EditorRole.MetadataEditor));
  }

  List<FilterDefinition> generateSeriesFilters(BuildContext context) {
    List<FilterOption> typeOptions = DatasetType.values.map((v) 
          => FilterOption(
              label: v.getText(context, Localizations.localeOf(context).languageCode),
              value: v.index)).toList();
    
    return [
      EnumFilter<XSchemaSeries, int>(
        fieldName: "type", 
        label: AppLocalizations.of(context)!.typesField, 
        filterOptions: typeOptions,
        filterTarget: (XSchemaSeries item) => item.type,
        modeOptionsEnabled: true),
      BoolFilter<XSchemaSeries, bool>(
        fieldName: "userRoles", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XSchemaSeries item) => item.userRoles.contains(EditorRole.MetadataEditor) 
          || item.userRoles.contains(EditorRole.OwnershipEditor))
    ];
  }
// -------------------------------------------------------------------------------------------------------- APPS --------------------------------------------------------------------------------------------

  int getAppListLength() {
    return apps.length;
  }

  XApp getApp(int index) {
    return apps[index];
  }

  String getAppAttributesSummary(BuildContext context, XApp app) {
    String locale = Localizations.localeOf(context).languageCode;
    Map<String, String> datasetTitle = app.activeResourceTitle;
    String displayTitle = datasetTitle[locale] ?? datasetTitle["en"] ?? datasetTitle.values.first;
    return "${AppLocalizations.of(context)!.dataset}: ${displayTitle} | ${AppLocalizations.of(context)!.template}: ${app.templateTitle}";
  }

  bool isAppEditable(XApp app) {
    return app.isDefault != true && (app.userRoles.contains(EditorRole.MetadataEditor) 
      || app.userRoles.contains(EditorRole.OwnershipEditor));
  }

  bool isAppDeletable(XApp app) {
    return app.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool canUserInsertApps() {
    return appTemplates.isNotEmpty && 
      appTemplates.any((tml) => tml.userRoles.contains(EditorRole.MetadataEditor));
  }

  bool areAppFlagsEditable(XApp app) {
    return app.isDefault != true && app.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isAppDeployable(XApp app) {
    XAppTemplate template = appTemplates.firstWhere((tml) => tml.identifier == app.templateUri);
    return app.userRoles.contains(EditorRole.MetadataEditor) && template.isReady == true && app.isDefault != true;
  }

  Color getStatusColor(AppStatus status) {
  switch (status) {
    case AppStatus.Created:
      return DoorColor.grey;
    case AppStatus.InProcessing:
      return DoorColor.cyan;
    case AppStatus.Ready:
      return DoorColor.darkEmph;
    case AppStatus.HasErrors:
      return DoorColor.red;
  }
}

List<FilterDefinition> generateAppFilters(BuildContext context) {
    List<FilterOption> typeOptions = AppStatus.values.map((v) 
          => FilterOption(
              label: v.getText(context),
              value: v.index)).toList();
    
    var templateOptions = appTemplates.map((t)
      => FilterOption(label: t.title, value: t.identifier)).toList();
    
    return [
      EnumFilter<XApp, int>(
        fieldName: "status", 
        label: AppLocalizations.of(context)!.statusField, 
        filterOptions: typeOptions,
        filterTarget: (XApp item) => item.status.index),
      EnumFilter<XApp, String>(
        fieldName: "templateUri", 
        label: AppLocalizations.of(context)!.template, 
        filterOptions: templateOptions, 
        filterTarget: (XApp item) => item.templateUri
        ),
      // TODO - source resources?
      
      BoolFilter<XApp, bool>(
        fieldName: "isEnabled", 
        label: AppLocalizations.of(context)!.enabled,
        filterTarget: (XApp item) => item.isEnabled
        ),
      BoolFilter<XApp, bool>(
        fieldName: "isVisible", 
        label: AppLocalizations.of(context)!.visible,
        filterTarget: (XApp item) => item.isVisible
        ),
      BoolFilter<XApp, bool>(
        fieldName: "userRoles", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XApp item) => item.userRoles.contains(EditorRole.MetadataEditor) 
          || item.userRoles.contains(EditorRole.OwnershipEditor))
    ];
  }

// -------------------------------------------------------------------------------------------------------- APP TEMPLATES --------------------------------------------------------------------------------------------

  int getTemplateListLength() {
    return appTemplates.length;
  }

  XAppTemplate getTemplate(int index) {
    return appTemplates[index];
  }

  bool canUserInsertTemplates() {
    return schemaResources.any((schema) 
      => seriesResources.firstWhere((series) => series.identifier == schema.seriesIdentifier).userRoles.contains(EditorRole.MetadataEditor));
  }

  bool isTemplateEditable(XAppTemplate tml) {
    return tml.userRoles.contains(EditorRole.MetadataEditor) 
      || tml.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isTemplateDeletable(XAppTemplate template) {
    var tml = template;
    return tml.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isTemplateGeneratable(XAppTemplate tml) {
    return tml.userRoles.contains(EditorRole.MetadataEditor);
  }

  void refreshTemplateIsCompiled(String templateUri) {
    int index = appTemplates.indexWhere((tml) => tml.identifier == templateUri);
    if (index != -1) {
      appTemplates[index].isReady = true;
    }
  }

  List<FilterDefinition> generateTemplateFilters(BuildContext context) {

    Set<String> languageCodes = appTemplates.map((t) 
      => t.language).toSet();
    List<FilterOption> languageOptions = FilteringCommon.generateFilterOptionsFromIterable(languageCodes) ?? [];

    List<FilterOption> schemaOptions = schemaResources.map((s)
      => FilterOption(label: s.title, value: s.identifier)).toList();
    
    return [
      EnumFilter<XAppTemplate, String>(
        fieldName: "language", 
        label: AppLocalizations.of(context)!.languages, 
        filterOptions: languageOptions,
        filterTarget: (XAppTemplate item) => item.language),
      EnumFilter<XAppTemplate, String>(
        fieldName: "schemaUri", 
        label: AppLocalizations.of(context)!.schema, 
        filterOptions: schemaOptions,
        filterTarget: (XAppTemplate item) => item.schemaUri),
      BoolFilter<XAppTemplate, bool>(
        fieldName: "isCompiled", 
        label: AppLocalizations.of(context)!.isCompiled, 
        filterTarget: (XAppTemplate item) => item.isReady
        ),
      BoolFilter<XAppTemplate, bool>(
        fieldName: "userRoles", 
        label: AppLocalizations.of(context)!.editableByMe, 
        filterTarget: (XAppTemplate item) => item.userRoles.contains(EditorRole.MetadataEditor) 
          || item.userRoles.contains(EditorRole.OwnershipEditor))
    ];
  }
}