import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/door_app_bar.dart';
import 'package:flutter/material.dart';

class VMainPanel extends StatelessWidget {
  final Widget _body;
  final AppBar _appBar;
  const VMainPanel(this._appBar, this._body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }
}

class VMainPanelFactory {
  const VMainPanelFactory(this._appBarFactory);
  final IAppBarFactory _appBarFactory;
  static late XUserAccount? userAccount;
  VMainPanel get(context, icon, text, isMainMenu, body, [notAuthenticated = false]) => VMainPanel(
        _appBarFactory.get(context, icon, text, isMainMenu, notAuthenticated ? null : userAccount),
        body,
      );
}
