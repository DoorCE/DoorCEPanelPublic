import 'package:doorce_panel/common/types/app_status.dart';
import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/common/view_elements/choice_dialog.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

abstract interface class IUCViewApp {
  Future<String?> showAppChoiceDialog(BuildContext context, List<XApp> apps);
  Future<void> viewAppSelected(BuildContext context, List<XApp> apps, String datasetUri);
  Future<void> viewDefaultApp(BuildContext context, XApp app, String datasetUri);
}
  
class UCViewApp with ExceptionHandler implements IUCViewApp {

  const UCViewApp();

  @override
  Future<String?> showAppChoiceDialog(BuildContext context, List<XApp> apps) async {
    return await showChoiceDialog(
        context,
        AppLocalizations.of(context)!.selectApp,
        AppLocalizations.of(context)!.goToApp,
        {for (var app in apps) app.identifier: app.title},
      );
  }

  @override
  Future<void> viewDefaultApp(BuildContext context, XApp app, String datasetUri) async {
    Logger.root.info("[UCViewApp viewDefaultApp] Launching app url... ");
    await tryForApiExceptions(context, () async {
      Logger.root.info("[UCViewApp viewDefaultApp] UDAS_PLATFORM_URL: ${const String.fromEnvironment("UDAS_PLATFORM_URL")}");
      final appUrl = Uri.parse(const String.fromEnvironment("UDAS_PLATFORM_URL") + "#/run_app:" + app.identifier + ":" + datasetUri);
      Logger.root.info("[UCViewApp viewDefaultApp] App URL: $appUrl");
      launchUrl(
          appUrl,
          webOnlyWindowName: '_blank');
    });
  }

  @override
  Future<void> viewAppSelected(BuildContext context, List<XApp> apps, String datasetUri) async {
    
    await tryForApiExceptions(context, () async {
      String? appUri = await showAppChoiceDialog(context, apps);

      if (appUri == null || appUri.isEmpty) {
        return;
      }

      Logger.root.info("[UCViewApp viewSelectedApp] Launching app url... ");
      Logger.root.info("[UCViewApp viewSelectedApp] UDAS_PLATFORM_URL: ${const String.fromEnvironment("UDAS_PLATFORM_URL")}");
      final appUrl = Uri.parse(const String.fromEnvironment("UDAS_PLATFORM_URL") + "#/run_app:" + appUri + ":" + datasetUri);
      Logger.root.info("[UCViewApp viewSelectedApp] App URL: $appUrl");
      launchUrl(
        Uri.parse(const String.fromEnvironment("UDAS_PLATFORM_URL") + "#/run_app:" + appUri + ":" + datasetUri),
        webOnlyWindowName: '_blank');
      
    });
  }
}
