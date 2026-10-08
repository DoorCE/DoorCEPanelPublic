import 'package:doorce_panel/navigation/router_service.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import '../common/consts/routing_prefixes.dart';
import '../locales/gen_l10n/app_localizations.dart';
import '../modules/agent_mgmt/usecases/show_agent_management.dart';
import '../modules/agent_mgmt/usecases/show_organization_details.dart';
import '../modules/agent_mgmt/usecases/show_person_details.dart';
import '../modules/agent_mgmt/usecases/show_upsert_organization.dart';
import '../modules/agent_mgmt/usecases/show_upsert_person.dart';
import '../modules/agent_mgmt/usecases/show_upsert_user.dart';
import '../common/view_elements/snack_message.dart';
import '../modules/data_mgmt/usecases/show_data_management.dart';
import '../modules/data_mgmt/usecases/show_dataset_content.dart';
import '../modules/data_mgmt/usecases/show_distribution_preview.dart';
import '../modules/data_mgmt/usecases/show_series_content.dart';
import '../modules/data_mgmt/usecases/show_upsert_distribution.dart';
import '../modules/main_panel/usecases/start.dart';
import '../modules/main_panel/view/main_panel.dart';
import '../modules/metadata_mgmt/usecases/show_catalogues.dart';
import '../modules/metadata_mgmt/usecases/show_open_series.dart';
import '../modules/metadata_mgmt/usecases/show_open_service.dart';
import '../modules/metadata_mgmt/usecases/show_upsert_catalogue.dart';
import '../modules/metadata_mgmt/usecases/show_upsert_dataset.dart';
import '../modules/metadata_mgmt/usecases/show_upsert_series.dart';
import '../modules/metadata_mgmt/usecases/show_upsert_service.dart';
import '../modules/schema_mgmt/usecases/show_schema_management.dart';
import '../modules/schema_mgmt/usecases/show_upsert_app.dart';
import '../modules/schema_mgmt/usecases/show_upsert_schema.dart';
import '../modules/schema_mgmt/usecases/show_upsert_schema_series.dart';
import '../modules/schema_mgmt/usecases/show_upsert_template.dart';

class AppRouterDelegate extends RouterDelegate<(String, bool)> {
  AppRouterDelegate({required RouterService routerService})
      : _routerService = routerService;

  final RouterService _routerService;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;


  List<Page<dynamic>> createPages() {
    List<Page<dynamic>> pages = [];
    final navigationStack = _routerService.navigationStack.value;
    for (int index = 0; index < navigationStack.length; index++) {
      final route = navigationStack[index];
      pages.add(
          MaterialPage(
              child: route.$2 ?? _route(route.$1)
          ));
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: createPages(),
      onDidRemovePage: (page) {
        Logger.root.fine('[RouterDelegate onDidRemovePage] page removed: ${page.name}');
        _routerService.pop();
      },
    );
  }

  @override
  Future<bool> popRoute() async {
    Logger.root.fine('[RouterDelegate popRoute] pop route called');

    if (_routerService.navigationStack.value.length <= 1) {
      return false;
    }

    Navigator.of(_navigatorKey.currentContext!).pop();
    // _routerService.pop();
    return true;
  }

  Future<void> forcePopRoute() async {
    Logger.root.fine('[RouterDelegate forcePopRoute] force pop route called');
    Navigator.of(_navigatorKey.currentContext!).pop();
  }

  @override
  (String, bool)? get currentConfiguration {
    if (_routerService.navigationStack.value.isEmpty) {
      return null;
    }
    return (_routerService.navigationStack.value.last.$1, false);
  }

  @override
  Future<void> setNewRoutePath((String, bool) configuration) async {
    if (configuration.$1 == currentConfiguration?.$1) {
      if (!configuration.$2) // URL address entered manually but same as current route, refresh the page
        _routerService.referesh();
    } else if (!configuration.$2 || !_routerService.tryNavigateTo(configuration.$1))
      // URL address entered manually or selected an item from the "back/forward" menu but failed to navigate to it                          
      _routerService.replaceAll(configuration.$1, null);
  }

  @override
  void addListener(VoidCallback listener) {
    _routerService.navigationStack.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerService.navigationStack.removeListener(listener);
  }
  
  // PRIVATE METHODS

  static Widget _route (String route) {
    Logger.root.fine('[Main router route] routing to: $route');
    int firstColonIndex = route.indexOf(':');
    String? routingPrefix = -1 != firstColonIndex ? route.substring(
        0, firstColonIndex) : route;
    List<String> routingParams = -1 != firstColonIndex ? route.substring(routingPrefix.length + 1).split(':') : [];

    Widget routeWidget;
    String param0, param1;

    try{
      switch (routingPrefix) {
        case RoutingPrefixes.agentManagement:
          Logger.root.fine('Routing to agent management with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowAgentManagement>().showAgentManagementSelected(
              context, routingParams.elementAtOrNull(0) ?? ""));
          break;
        case RoutingPrefixes.previewOrganisation:
          Logger.root.fine('Routing to organization details with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowOrganizationDetails>().showOrganizationDetailsSelected(
              context, routingParams.elementAtOrNull(0) ?? ""));
          break;
        case RoutingPrefixes.previewPerson:
          Logger.root.fine('Routing to person details with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowPersonDetails>().showPersonDetailsSelected(
              context, routingParams.elementAtOrNull(0) ?? ""));
          break;
        case RoutingPrefixes.upsertOrganisation:
          Logger.root.fine('Routing to upsert organization with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertOrganization>().showUpsertOrganizationSelected(
              context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.upsertPerson:
          Logger.root.fine('Routing to upsert person with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertPerson>().showUpsertPersonSelected(
              context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.dataManagement:
          Logger.root.fine('Routing to data management');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowDataManagement>().showDataManagementSelected(context));
          break;
        case RoutingPrefixes.datasetContent:
          Logger.root.fine('Routing to dataset content with query: ${routingParams.elementAtOrNull(0)}');
          var param0 = routingParams[0];
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowDatasetContent>().showDatasetContentSelected(context, param0));
          break;
        case RoutingPrefixes.previewDistribution:
          Logger.root.fine('Routing to distribution content with query: ${routingParams.elementAtOrNull(0)}');
          param0 = routingParams[0];
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowDistributionPreview>().showDistributionContentSelected(context, param0));
          break;
        case RoutingPrefixes.previewDatasetSeries:
          Logger.root.fine('Routing to series details with query: ${routingParams.elementAtOrNull(0)}');
          param0 = routingParams[0];
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowSeriesContent>().showSeriesContentSelected(context, param0));
          break;
        case RoutingPrefixes.upsertDistribution:
          Logger.root.fine('Routing to upsert distribution with query: ${routingParams.elementAtOrNull(0)}, ${routingParams.elementAtOrNull(1)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertDistribution>().showUpsertDistributionSelected(context, routingParams.elementAtOrNull(0)!, routingParams.elementAtOrNull(1)));
          break;
        case RoutingPrefixes.catalogues:
          Logger.root.fine('Routing to catalogues with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowCatalogues>().showCataloguesSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.seriesContent:
          Logger.root.fine('Routing to series content with query: ${routingParams.elementAtOrNull(0)}');
          param0 = routingParams[0];
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowOpenSeries>()
              .showSeriesContentSelected(context, param0));
          break;
        case RoutingPrefixes.openService:
          Logger.root.fine('Routing to service content with query: ${routingParams.elementAtOrNull(0)}}');
          param0 = routingParams[0];
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowOpenService>().showServicesContentSelected(context, param0));
          break;
        case RoutingPrefixes.upsertCatalogue:
          Logger.root.fine('Routing to upsert catalogue with query: ${routingParams.elementAtOrNull(0)}, ${routingParams.elementAtOrNull(1)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertCatalogue>()
              .showUpsertCatalogueSelected(context, routingParams.elementAtOrNull(0), routingParams.elementAtOrNull(1)));
          break;
        case RoutingPrefixes.upsertDataset:
          Logger.root.fine('Routing to upsert dataset with query: ${routingParams.elementAtOrNull(0)}, ${routingParams.elementAtOrNull(1)}, ${routingParams.elementAtOrNull(1)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertDataset>().showUpsertDatasetSelected(
              context,
              routingParams.elementAtOrNull(0),
              routingParams.elementAtOrNull(1),
              routingParams.elementAtOrNull(2)));
          break;
        case RoutingPrefixes.upsertSeries:
          Logger.root.fine('Routing to upsert series with query: ${routingParams.elementAtOrNull(0)}, ${routingParams.elementAtOrNull(1)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertSeries>().showUpsertSeriesSelected(context, routingParams.elementAtOrNull(0), routingParams.elementAtOrNull(1)));
          break;
        case RoutingPrefixes.upsertService:
          Logger.root.fine('Routing to upsert service with query: ${routingParams.elementAtOrNull(0)}, ${routingParams.elementAtOrNull(1)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertService>().showUpsertServiceSelected(
              context,
              routingParams.elementAtOrNull(0),
              routingParams.elementAtOrNull(1)));
          break;
        case RoutingPrefixes.schemaManagement:
          Logger.root.fine('Routing to schema management');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowSchemaManagement>().showSchemaManagementSelected(context));
          break;
        case RoutingPrefixes.upsertSchemaSeries:
          Logger.root.fine('Routing to upsert schema series with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertSchemaSeries>().showUpsertSchemaSeriesSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.upsertSchema:
          Logger.root.fine('Routing to upsert schema with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertSchema>().showUpsertSchemaSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.upsertUser:
          Logger.root.fine('Routing to upsert user with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertUser>().showUpsertUserSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.upsertApp:
          Logger.root.fine('Routing to upsert app with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertApp>().showUpsertAppSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.upsertTemplate:
          Logger.root.fine('Routing to upsert template with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context
              .read<IUCShowUpsertTemplate>().showUpsertTemplateSelected(context, routingParams.elementAtOrNull(0)));
          break;
        case RoutingPrefixes.previewDataset:
          Logger.root.fine('Routing to preview dataset with query: ${routingParams.elementAtOrNull(0)}');
          routeWidget = _UseCaseWidget((context) => context              
            .read<IUCShowUpsertDataset>().showUpsertDatasetSelected(context, routingParams.elementAtOrNull(0), null, null, true));
          break;
        default:
          Logger.root.fine('Routing to main menu...');
          routeWidget = _UseCaseWidget((context) => context.read<IUCStart>().startSelected(context));
          break;
      }
    } catch (e) {
      Logger.root.severe('Error during routing: $e');
      routeWidget = _UseCaseWidget((context) => context.read<IUCStart>().startSelected(context));
    }

    return routeWidget;
  }
}

// Helper widget to trigger use case logic once
class _UseCaseWidget extends StatefulWidget {
  final void Function(BuildContext) useCaseCall;
  const _UseCaseWidget(this.useCaseCall, {Key? key}) : super(key: key);

  @override
  State<_UseCaseWidget> createState() => _UseCaseWidgetState();
}

class _UseCaseWidgetState extends State<_UseCaseWidget> {
  late Future<void> _callFirst;

  @override
  void initState() {
    super.initState();
    _callFirst = _initAsync();
  }

  Future<void> _initAsync() async {
    bool wasAuthenticated = AuthStatus.authenticated == 
        await context.read<IUCStart>().checkTokenAndSetAccount(context);

    final navigatorKey = context.read<AppRouterDelegate>().navigatorKey;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        Logger.root.fine("[UCWidget postFrameCallback] widget unmounted, skipping");
        return;
      }
      final currentContext = navigatorKey.currentContext; // make sure to use the current context 
      if (currentContext == null) return;
      if (wasAuthenticated && null == VMainPanelFactory.userAccount) {
        Logger.root.fine("[UCWidget postFrameCallback] auth backend error");
        SnackMessage().show(currentContext, true, text: AppLocalizations.of(currentContext)!.authBackendError);
      } else {
        Logger.root.fine("[UCWidget postFrameCallback] use case call");
        // TODO - differentiate between authenticated user and not authenticated user
        widget.useCaseCall(currentContext);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Logger.root.fine("[UCWidget builder] rendering the loading screen");
    return FutureBuilder(
      future: _callFirst,
      builder: (context, snapshot) => Scaffold(
        body: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset('images/doorce_loading.png'),
          ),
        ),
      ),
    );
  }
}