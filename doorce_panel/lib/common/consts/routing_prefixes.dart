class RoutingPrefixes {
  static const String root = "/";
  static const String agentManagement = "/agent_management";
  static const String previewOrganisation = "/preview_organisation";
  static const String previewPerson = "/preview_person";
  static const String upsertOrganisation = "/upsert_organisation";
  static const String upsertPerson = "/upsert_person";
  static const String upsertUser = "/upsert_user";

  static const String dataManagement = "/data_management";
  static const String datasetContent = "/dataset_content";
  static const String previewDistribution = "/preview_distribution";
  static const String seriesContent = "/series_content";
  static const String upsertDistribution = "/upsert_distribution";

  static const String catalogues = "/catalogues";
  static const String openService = "/open_service";
  static const String upsertCatalogue = "/upsert_catalogue";
  static const String previewCatalogue = "/preview_catalogue";
  static const String upsertDataset = "/upsert_dataset";
  static const String previewDataset = "/preview_dataset";
  static const String upsertSeries = "/upsert_series";
  static const String upsertService = "/upsert_service";
  static const String previewService = "/preview_service";
  static const String previewDatasetSeries = "/preview_series";
  static const String openDatasetSeries = "/open_series";
  
  static const String schemaManagement = "/schema_management";
  static const String upsertSchemaSeries = "/upsert_schema_series";
  static const String previewSchemaSeries = "/preview_schema_series";
  static const String upsertSchema = "/upsert_schema";
  static const String previewSchema = "preview_schema";
  static const String upsertApp = "/upsert_app";
  static const String previewApp = "/preview_app";
  static const String upsertTemplate = "/upsert_template";
  static const String previewTemplate = "/preview_template";

  static const List<String> values = [
    root, 
    agentManagement,
    previewOrganisation,
    previewPerson,
    upsertOrganisation,
    upsertPerson,
    dataManagement,
    datasetContent,
    previewDistribution,
    previewDatasetSeries,
    upsertDistribution,
    catalogues,
    seriesContent,
    openService,
    upsertCatalogue,
    upsertDataset,
    upsertSeries,
    upsertService,
    schemaManagement,
    upsertSchemaSeries,
    upsertSchema,
    upsertUser,
    upsertApp,
    upsertTemplate,
    previewDataset,
    previewCatalogue,
    previewService,
    previewSchema,
    previewSchemaSeries,
    previewApp,
    previewTemplate,
    openDatasetSeries,
  ];
}