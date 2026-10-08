import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_panel.dart';
import 'package:doorce_panel/modules/main_panel/view/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

abstract interface class IPMainMenu{
  Widget firstShow(BuildContext context);
  show(BuildContext context);
  showAuthFailed(BuildContext context);
}

class PMainMenu extends AbstractPresenter implements IPMainMenu{
  final VMainMenuFactory _vMainMenuFactory;
  const PMainMenu(this._vMainMenuFactory) : super("/");
  
  @override
  Widget firstShow(BuildContext context) {
    return _vMainMenuFactory.get();
  }

  @override
  show(BuildContext context) {
    pushWindow(context, 'images/options.png', AppLocalizations.of(context)!.mainMenu, true,
                          _vMainMenuFactory.get());
  }

  @override
  showAuthFailed(BuildContext context) { 
    pushWindow(context, 'images/options.png', AppLocalizations.of(context)!.mainMenu, true,
                          _vMainMenuFactory.getAuthFailed(context), true);
  }
}