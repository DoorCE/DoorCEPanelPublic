import 'package:doorce_panel/common/consts/routing_prefixes.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/delete_agent.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/delete_user.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_person_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_organization.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_organization_details.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_person.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_user.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/agent_management_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/organization_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/person_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_agent_management_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_person_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_organization_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_organization_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_person_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_upsert_user_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_organization_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_person_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/upsert_user_window.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/delete_data.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/delete_dataset_from_series.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/delete_distribution.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_data_management.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_dataset_content.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_distribution_preview.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_series_content.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/show_upsert_distribution.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/upload_data.dart';
import 'package:doorce_panel/modules/data_mgmt/usecases/view_app.dart';
import 'package:doorce_panel/modules/data_mgmt/view/data_management_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/dataset_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/distribution_preview_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_data_management_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_dataset_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_distribution_preview_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_series_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_upsert_distribution_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/series_content_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/upsert_distribution_window.dart';
import 'package:doorce_panel/modules/login/usecases/show_login.dart';
import 'package:doorce_panel/modules/login/view/controllers/c_login_window.dart';
import 'package:doorce_panel/modules/login/view/login_window.dart';
import 'package:doorce_panel/modules/login/view/presenters/p_login_window.dart';
import 'package:doorce_panel/modules/main_panel/view/door_app_bar.dart';
import 'package:doorce_panel/modules/main_panel/view/door_drawer.dart';
import 'package:doorce_panel/modules/main_panel/view/main_panel.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/main_panel/view/main_menu.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_menu.dart';
import 'package:doorce_panel/modules/main_panel/view/controllers/c_main_menu.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_catalogue.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/delete_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/publish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_catalogues.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_open_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_open_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_catalogue.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_series.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/show_upsert_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/usecases/unpublish_dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/catalogues_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_catalogues_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_open_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_open_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_catalogue_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/open_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/open_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_catalogue_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_dataset_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_dataset_window.dart';
import 'package:doorce_panel/modules/main_panel/view/controllers/c_door_drawer.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/upsert_service_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_schema.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/delete_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/deploy_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/generate_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/refresh_app_statuses.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_schema_management.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/show_upsert_template.dart';
import 'package:doorce_panel/modules/schema_mgmt/usecases/update_app.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_template_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_app_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_app_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_schema_management_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_schema_series_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/presenters/p_upsert_schema_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/schema_management_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_schema_series_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_schema_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/upsert_template_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/app_mgmt.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:doorce_panel/services/data_upload_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/services/storage_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:logging/logging.dart';

import 'navigation/app_router_delegate.dart';
import 'navigation/route_information_parser.dart';
import 'navigation/router_service.dart';

void main() {
  final logLevelStr = const String.fromEnvironment('DEBUG', defaultValue: 'FALSE').toUpperCase();
  Logger.root.level = logLevelStr == "TRUE" ? Level.ALL : Level.CONFIG;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: UDAS-Panel: ${record.message}');
  });
  Logger.root.info("UDAS_PLATFORM_URL: ${const String.fromEnvironment("UDAS_PLATFORM_URL")}");
  MultiProvider provider = setupDependencies();
  runApp(provider);
}

MultiProvider setupDependencies() {
  List<SingleChildWidget> providerList = List<SingleChildWidget>.empty(growable: true);
  
  // Router delegate
  providerList.add(Provider(create: (context) => RouterService()));
  providerList.add(ListenableProvider<AppRouterDelegate>(
    create: (context) => AppRouterDelegate(routerService: context.read()),
  ));

  // NEW PROVIDER FOR SERVICES
  providerList.add(Provider<AuthAPI>(create: (context) => KeycloakAuthService()));
  providerList.add(Provider<StorageAPI>(create: (context) => StorageManagement(context.read())));
  providerList.add(Provider<IconAPI>(create: (context) => IconManagement(context.read())));
  providerList.add(Provider<DatasetManagementAPI>(create: (context) => DatasetManagement(context.read(),context.read())));
  providerList.add(Provider<AgentManagementAPI>(create: (context) => AgentManagement(context.read())));
  providerList.add(Provider<VocabularyManagementAPI>(create: (context) => VocabularyManagement(context.read())));
  providerList.add(Provider<SchemaAPI>(create: (context) => SchemaManagement(context.read())));
  providerList.add(Provider<AppManagementAPI>(create: (context) => AppManagement(context.read())));
  providerList.add(Provider<DataUploadAPI>(create: (context) => DataUpload(context.read())));

  // View widgets with Controllers and Presenters
  providerList.add(Provider(create: (context) => const CMainMenu()));
  providerList.add(Provider(create: (context) => const CDoorDrawer()));
  providerList.add(Provider<IDrawerFactory>(create: (context) => VDoorDrawerFactory(context.read())));
  providerList.add(Provider<IAppBarFactory>(create: (context) => VDoorAppBarFactory(context.read())));
  providerList.add(Provider(create: (context) => VMainPanelFactory(context.read())));

  providerList.add(Provider(create: (context) => const CLoginWindow()));
  providerList.add(Provider(create: (context) => VLoginWindowFactory(context.read())));
  providerList.add(Provider<IPLoginWindow>(create: (context) => const PLoginWindow()));

  providerList.add(Provider(create: (context) => VCataloguesWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertDatasetWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertCatalogueWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertSeriesWindowFactory()));
  providerList.add(Provider(create: (context) => VOpenSeriesWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertServiceWindowFactory()));
  providerList.add(Provider(create: (context) => VOpenServiceWindowFactory()));
  providerList.add(Provider(create: (context) => VDataManagementWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertDistributionWindowFactory()));
  providerList.add(Provider(create: (context) => VDatasetContentWindowFactory()));
  providerList.add(Provider(create: (context) => VDistributionPreviewWindowFactory()));
  providerList.add(Provider(create: (context) => VAgentManagementWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertPersonWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertOrganizationWindowFactory()));
  providerList.add(Provider(create: (context) => VOrganizationDetailsWindowFactory()));
  providerList.add(Provider(create: (context) => VPersonDetailsWindowFactory()));
  providerList.add(Provider(create: (context) => VSchemaManagementWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertSchemaWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertSchemaSeriesWindowFactory()));
  providerList.add(Provider(create: (context) => VSeriesContentWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertUserWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertAppWindowFactory()));
  providerList.add(Provider(create: (context) => VUpsertTemplateWindowFactory()));

  providerList.add(Provider<IPCataloguesWindow>(create: (context) => PCataloguesWindow(context.read())));
  providerList.add(Provider<IPUpsertDatasetWindow>(create: (context) => PUpsertDatasetWindow(context.read())));
  providerList.add(Provider<IPUpsertCatalogueWindow>(create: (context) => PUpsertCatalogueWindow(context.read())));
  providerList.add(Provider<IPUpsertSeriesWindow>(create: (context) => PUpsertSeriesWindow(context.read())));
  providerList.add(Provider<IPOpenSeriesWindow>(create: (context) => POpenSeriesWindow(context.read())));
  providerList.add(Provider<IPUpsertServiceWindow>(create: (context) => PUpsertServiceWindow(context.read())));
  providerList.add(Provider<IPOpenServiceWindow>(create: (context) => POpenServiceWindow(context.read())));
  providerList.add(Provider<IPDataManagementWindow>(create: (context) => PDataManagementWindow(context.read())));
  providerList.add(Provider<IPUpsertDistributionWindow>(create: (context) => PUpsertDistributionWindow(context.read())));
  providerList.add(Provider<IPDatasetContentWindow>(create: (context) => PDatasetContentWindow(context.read())));
  providerList.add(Provider<IPDistributionPreviewWindow>(create: (context) => PDistributionPreviewWindow(context.read())));
  providerList.add(Provider<IPAgentManagementWindow>(create: (context) => PAgentManagementWindow(context.read())));
  providerList.add(Provider<IPUpsertPersonWindow>(create: (context) => PUpsertPersonWindow(context.read())));
  providerList.add(Provider<IPUpsertOrganizationWindow>(create: (context) => PUpsertOrganizationWindow(context.read())));
  providerList.add(Provider<IPOrganizationDetailsWindow>(create: (context) => POrganizationDetailsWindow(context.read())));
  providerList.add(Provider<IPPersonDetailsWindow>(create: (context) => PPersonDetailsWindow(context.read())));
  providerList.add(Provider<IPSchemaManagementWindow>(create: (context) => PSchemaManagementWindow(context.read())));
  providerList.add(Provider<IPUpsertSchemaWindow>(create: (context) => PUpsertSchemaWindow(context.read())));
  providerList.add(Provider<IPUpsertSchemaSeriesWindow>(create: (context) => PUpsertSchemaSeriesWindow(context.read())));
  providerList.add(Provider<IPSeriesContentWindow>(create: (context) => PSeriesContentWindow(context.read())));
  providerList.add(Provider<IPUpsertUserWindow>(create: (context) => PUpsertUserWindow(context.read())));
  providerList.add(Provider<IPUpsertAppWindow>(create: (context) => PUpsertAppWindow(context.read())));
  providerList.add(Provider<IPUpsertTemplateWindow>(create: (context) => PUpsertTemplateWindow(context.read())));

  providerList.add(Provider(create: (context) => VMainMenuFactory(context.read())));
  providerList.add(Provider<IPMainMenu>(create: (context) => PMainMenu(context.read())));
  
  // Use Cases
  providerList.add(Provider<IUCLogin>(create: (context) => UCLogin(context.read())));
  providerList.add(Provider<IUCStart>(create: (context) => UCStart(context.read(), context.read(), context.read())));

  providerList.add(Provider<IUCShowCatalogues>(create: (context) =>
    UCShowCatalogues(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertCatalogue>(create: (context) => 
    UCShowUpsertCatalogue(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteCatalogue>(create: (context) => 
    UCDeleteCatalogue(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteDataset>(create: (context) => 
    UCDeleteDataset(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteSeries>(create: (context) => 
    UCDeleteSeries(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteService>(create: (context) => 
    UCDeleteService(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertSeries>(create: (context) =>
    UCShowUpsertSeries(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertDataset>(create: (context) =>
    UCShowUpsertDataset(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowOpenSeries>(create: (context) =>
    UCShowOpenSeries(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertService>(create: (context) =>
    UCShowUpsertService(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowOpenService>(create: (context) =>
    UCShowOpenService(context.read(), context.read())));
  providerList.add(Provider<IUCShowDataManagement>(create: (context) =>
    UCShowDataManagement(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertDistribution>(create: (context) =>
    UCShowUpsertDistribution(context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowDatasetContent>(create: (context) =>
    UCShowDatasetContent(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowDistributionPreview>(create: (context) =>
    UCShowDistributionPreview(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteDistribution>(create: (context) =>
    UCDeleteDistribution(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowAgentManagement>(create: (context) =>
    UCShowAgentManagement(context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertPerson>(create: (context) =>
    UCShowUpsertPerson(context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertOrganization>(create: (context) =>
    UCShowUpsertOrganization(context.read(), context.read())));
  providerList.add(Provider<IUCShowOrganizationDetails>(create: (context) =>
    UCShowOrganizationDetails(context.read(), context.read())));
  providerList.add(Provider<IUCShowPersonDetails>(create: (context) =>
    UCShowPersonDetails(context.read(), context.read())));
    providerList.add(Provider<IUCDeleteAgent>(create: (context) => 
    UCDeleteAgent(context.read(), context.read())));
  providerList.add(Provider<IUCShowSchemaManagement>(create: (context) =>
    UCShowSchemaManagement(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertSchema>(create: (context) =>
    UCShowUpsertSchema(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertSchemaSeries>(create: (context) =>
    UCShowUpsertSchemaSeries(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteSchema>(create: (context) =>
    UCDeleteSchema(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteSchemaSeries>(create: (context) =>
    UCDeleteSchemaSeries(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowSeriesContent>(create: (context) =>
    UCShowSeriesContent(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteDatasetFromSeries>(create: (context) =>
    UCDeleteDatasetFromSeries(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertUser>(create: (context) =>
    UCShowUpsertUser(context.read(), context.read())));
  providerList.add(Provider<IUCDeleteUser>(create: (context) =>
    UCDeleteUser(context.read(), context.read())));
  providerList.add(Provider<IUCUpdateApp>(create: (context) =>
    UCUpdateApp(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertApp>(create: (context) =>
    UCShowUpsertApp(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteApp>(create: (context) =>
    UCDeleteApp(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteAppTemplate>(create: (context) =>
    UCDeleteAppTemplate(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCShowUpsertTemplate>(create: (context) =>
    UCShowUpsertTemplate(context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCUploadData>(create: (context) =>
    UCUploadData(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeleteData>(create: (context) =>
    UCDeleteData(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCGenerateTemplate>(create: (context) =>
    UCGenerateTemplate(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCDeployApp>(create: (context) =>
    UCDeployApp(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCRefreshAppStatuses>(create: (context) =>
    UCRefreshAppStatuses(context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCUnpublishDataset>(create: (context) =>
    UCUnpublishDataset(context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCPublishDataset>(create: (context) =>
    UCPublishDataset(context.read(), context.read(), context.read(), context.read(), context.read(), context.read(), context.read())));
  providerList.add(Provider<IUCViewApp>(create: (context) => UCViewApp()));

  return MultiProvider(providers: providerList, child: const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AppRouterDelegate routerDelegate;
  late final RouteInformationParser<Object> routeInformationParser;

  @override
  void initState() {
    super.initState();
    routerDelegate = context.read<AppRouterDelegate>();
    routeInformationParser = AppRouteInformationParser(routes: RoutingPrefixes.values);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "UDAS Data Management Panel"
    );
  }
}