import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/modules/main_panel/view/controllers/c_main_menu.dart';

class VMainMenu extends StatelessWidget {
  final CMainMenu _cMainMenu;
  const VMainMenu(this._cMainMenu, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewport = MediaQuery.sizeOf(context);

          final safeWidth =
          constraints.hasBoundedWidth && constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : viewport.width;

          final safeHeight =
          constraints.hasBoundedHeight && constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : viewport.height;

          double width = safeWidth * 1.2;
          double height = safeHeight;

          if (!width.isFinite || width <= 0) width = 800;
          if (!height.isFinite || height <= 0) height = 600;

          if (width < 800) width = 800;
          if (height < 600) height = 600;

          return SingleChildScrollView(
            child: Container(
              width: width,
              height: height,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard(
                        Icons.book,
                        AppLocalizations.of(context)!.dataManagement,
                        AppLocalizations.of(context)!.dataManagementDescription,
                        () => _cMainMenu.showDataManangementSelected(context),
                        width,
                        height,
                      ),
                      _buildCard(
                        Icons.folder,
                        AppLocalizations.of(context)!.cataloguing,
                        AppLocalizations.of(context)!.metadataManagementDescription,
                        () => _cMainMenu.showCataloguesSelected(context, ""),
                        width,
                        height,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 12,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCard(
                        Icons.schema,
                        AppLocalizations.of(context)!.schemaManagement,
                        AppLocalizations.of(context)!.schemaManagementDescription,
                        () => _cMainMenu.showSchemaManangementSelected(context),
                        width,
                        height,
                      ),
                      _buildCard(
                        Icons.people,
                        AppLocalizations.of(context)!.agentManagement,
                        AppLocalizations.of(context)!.agentManagementDescription,
                        () => _cMainMenu.showAgentManangementSelected(
                            context, ""),
                        width,
                        height,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(IconData icon, String title, String description,
      VoidCallback onClick, double width, double height) {
    return SizedBox(
      width: width / 3.7,
      height: height / 2.3,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: DoorColor.reverse,
        elevation: 8,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onClick,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 6,
                child: Center(child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(child: Column(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 50,
                        color: DoorColor.black,
                      ),
                      DoorText(
                        title,
                        DoorTextStyle.titleBlack,
                      ),
                    ],
                  )),
                )),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: DoorColor.darkEmph,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: DoorText(
                        description,
                        DoorTextStyle.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VMainMenuFactory {
  const VMainMenuFactory(this._cMainMenu);
  final CMainMenu _cMainMenu;
  VMainMenu get() => VMainMenu(_cMainMenu);
  Widget getAuthFailed(context) => new Center(
    child: DoorText(
      AppLocalizations.of(context)!.authKeycloakError,
      DoorTextStyle.titleBlack,
    ),
  );
}
