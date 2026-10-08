import 'package:doorce_panel/modules/main_panel/view/controllers/c_door_drawer.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IDrawerFactory {
  Widget get();
}

class VDoorDrawerFactory implements IDrawerFactory {
  const VDoorDrawerFactory(this._cDoorDrawer);
  final CDoorDrawer _cDoorDrawer;
  @override
  Widget get() => VDoorDrawer(_cDoorDrawer);
}

class VDoorDrawer extends StatelessWidget {
  final CDoorDrawer _cDoorDrawer;

  const VDoorDrawer(this._cDoorDrawer, {super.key});

  //TODO: configure the drawer depending on the actor role (only available options visible)

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.home),
          title: Text(AppLocalizations.of(context)!.mainMenu),
          onTap: () => _cDoorDrawer.homeSelected(context),
        ),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.file_copy),
            title: Text(AppLocalizations.of(context)!.datasets)),
        ListTile(
          leading: const Icon(Icons.map),
          title: Text(AppLocalizations.of(context)!.catalogue),
          onTap: () => _cDoorDrawer.catalogueSelected(context),
        ),
        ListTile(
            leading: const Icon(Icons.schema),
            title: Text(AppLocalizations.of(context)!.schemas)),
        ListTile(
            leading: const Icon(Icons.people),
            title: Text(AppLocalizations.of(context)!.agents)),
        const Divider(),
        ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text(AppLocalizations.of(context)!.profile)),
        ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings)),
        ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.logout)),
      ],
    ));
  }
}
