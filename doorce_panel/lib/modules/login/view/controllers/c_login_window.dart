import 'package:doorce_panel/modules/login/usecases/show_login.dart';
import 'package:doorce_panel/modules/login/view/viewmodel/m_login_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CLoginWindow {
  const CLoginWindow();

  Future<bool> authenticate(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return email == "test@test.com" && password == "password";
    } catch (e) {
      // TODO: handle authentication error
      return false;
    }
  }

  Future<bool> onLoginPressed(BuildContext context, MLoginWindow model) async {
    if (await authenticate(model.email, model.password)) {
      context.read<IUCLogin>().loggedIn(context);
      return true;
    } else {
      // TODO: SnackBar for error messages
      return false;
    }
  }
}
