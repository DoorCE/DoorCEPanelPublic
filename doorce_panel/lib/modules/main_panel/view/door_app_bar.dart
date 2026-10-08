import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_upsert_person.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:doorce_panel/modules/main_panel/view/controllers/c_main_menu.dart';
import 'package:doorce_panel/common/utils/app_version.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../navigation/app_router_delegate.dart';

abstract interface class IAppBarFactory {
  AppBar get(BuildContext context, String icon, String currentSection, bool isMainMenu, XUserAccount? userAccount);
}

class VDoorAppBarFactory implements IAppBarFactory {
  final CMainMenu _cMainMenu;

  const VDoorAppBarFactory(this._cMainMenu);

  @override
  AppBar get(BuildContext context, String icon, String currentSection, bool isMainMenu, XUserAccount? userAccount) =>
      AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight + 80,
        flexibleSpace: Column(
          children: [
            _buildHeader(context),
            _buildActions(context, currentSection, isMainMenu, userAccount),
          ],
        ),
      );

  Widget _buildHeader(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double rightPadding = screenWidth > 600 ? 200 : screenWidth * 0.1;

    return Expanded(
      flex: 7,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/header_image.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Image.asset('images/doorce_logo.png'),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(left: 200, right: rightPadding),
                child: DoorText(
                  AppLocalizations.of(context)!.panelName,
                  DoorTextStyle.title,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: DoorText(
                  AppVersion.version,
                  DoorTextStyle.label,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, String currentSection, bool isMainMenu, XUserAccount? userAccount) {

    final navigatorKey = context.read<AppRouterDelegate>().navigatorKey;

    // Home icon
    Widget homeIcon = DoorSimpleButtonIcon(
      AppLocalizations.of(context)!.main, Icons.home,
      () => navigatorKey.currentContext!.read<IUCStart>().startSelected(navigatorKey.currentContext!),
    );

    // Menu items
    Widget menuItems = isMainMenu ? Container() :
      DoorButtonTextRow([
      (
        AppLocalizations.of(context)!.dataManagement,
        () => _cMainMenu.showDataManangementSelected(navigatorKey.currentContext!),
        currentSection ==
            "${AppLocalizations.of(context)!.dataManagement}: ${AppLocalizations.of(context)!.main}"
      ),
      (
        AppLocalizations.of(context)!.cataloguing,
        () => _cMainMenu.showCataloguesSelected(navigatorKey.currentContext!, ""),
        currentSection ==
            "${AppLocalizations.of(context)!.catalogue}: ${AppLocalizations.of(context)!.main}"
      ),
      (
        AppLocalizations.of(context)!.schemaManagement,
        () => _cMainMenu.showSchemaManangementSelected(navigatorKey.currentContext!),
        currentSection ==
            "${AppLocalizations.of(context)!.schemas}: ${AppLocalizations.of(context)!.main}"
      ),
      (
        AppLocalizations.of(context)!.agentManagement,
        () => _cMainMenu.showAgentManangementSelected(navigatorKey.currentContext!, ""),
        currentSection ==
            "${AppLocalizations.of(context)!.agents}: ${AppLocalizations.of(context)!.main}"
      ),
    ]);

    // Utility icons
    Widget utilityIcons = DoorSimpleButtonIconRow([
      (AppLocalizations.of(context)!.profile + (null != userAccount?.personFullName ? ": " + userAccount!.personFullName! : ""),
        Icons.people, 
        null != userAccount?.personUri ?
          () => navigatorKey.currentContext!.read<IUCShowUpsertPerson>()
              .showUpsertPersonSelected(navigatorKey.currentContext!, userAccount?.personUri) 
          : null),
      // TODO - uncomment when user account settings are implemented
      // (AppLocalizations.of(context)!.settings, Icons.settings, () {}),
      (AppLocalizations.of(context)!.logout + (null != userAccount ? ": " + userAccount.userId : ""),
        Icons.logout, 
          () => navigatorKey.currentContext!.read<IUCStart>().logoutSelected(navigatorKey.currentContext!)),
    ]);

    return  Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: DoorColor.darkEmph,
          border: Border(
            top: BorderSide(color: DoorColor.black, width: 2),
            bottom: BorderSide(color: DoorColor.black, width: 2),
          ),
        ),
        child: Row(
          children: null != userAccount 
            ? [homeIcon, Expanded(child: menuItems), utilityIcons] 
            : []
        )
    );
  }
}
