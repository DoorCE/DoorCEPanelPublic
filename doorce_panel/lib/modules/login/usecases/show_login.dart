import 'package:doorce_panel/modules/login/view/presenters/p_login_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract interface class IUCLogin {
  loginSelected(BuildContext context);
  loggedIn(BuildContext context);
}

class UCLogin implements IUCLogin {
  final IPLoginWindow _pLogin;

  const UCLogin(this._pLogin);

  @override
  loginSelected(BuildContext context) {
    return _pLogin.show(context);
  }

  @override
  loggedIn(BuildContext context) {
    context.read<IUCStart>().startSelected(context);
  }
}
