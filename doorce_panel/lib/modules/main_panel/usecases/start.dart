import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/main_panel/view/main_panel.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/modules/main_panel/view/presenters/p_main_menu.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;

abstract interface class IUCStart{
  startSelected(BuildContext context);
  logoutSelected(BuildContext context);
  Future<AuthStatus> getAuthStatus();
  Future<void> refreshToken();
  Future<AuthStatus> checkTokenAndSetAccount(BuildContext context);
}

class UCStart implements IUCStart{

  final IPMainMenu _pMainMenu;
  final AuthAPI _authAPI;
  final AgentManagementAPI _agentAPI;

  
  const UCStart(this._pMainMenu, this._authAPI, this._agentAPI);

  @override
  startSelected(BuildContext context) async {
    Logger.root.fine('[UCStart startSelected] starting...');
    bool accTokenExists = AuthStatus.noToken != await _authAPI.getAuthStatus();
    if (accTokenExists){
      Logger.root.fine('[UCStart startSelected] access token exists, going to main menu');
      _pMainMenu.show(context);
    } else {
      // Check if the current URI is plain or is it a redirect from Keycloak (has the "code")
      final uri = Uri.parse(html.window.location.href);
      String? code = uri.queryParameters.containsKey('code') ? uri.queryParameters['code'] : null;
      Logger.root.fine(null != code ? '[UCStart startSelected] user is not authenticated, code found in URL: $code'
              : '[UCStart startSelected] user is not authenticated, starting authentication flow');
      accTokenExists = await _authAPI.authenticate(code);
      if (accTokenExists) {
        Logger.root.fine('[UCStart startSelected] user authenticated successfully (${html.window.location.href}), redirecting to main page');
      } else if (null != code) _pMainMenu.showAuthFailed(context);
    }
  }

  @override
  logoutSelected(BuildContext context) async {
    await _authAPI.logout();
    startSelected(context);
  }

  @override
  Future<AuthStatus> getAuthStatus() async {
    return await _authAPI.getAuthStatus();
  }

  Future<void> refreshToken() async {
    return await _authAPI.refresh();
  }
  
  @override
  Future<AuthStatus> checkTokenAndSetAccount(BuildContext context) async {
    Logger.root.fine('[UCStart checkTokenAndSetAccount] starting...');
    XUserAccount? userAccount;
    try {
      AuthStatus originalAuthStatus = await _authAPI.getAuthStatus();
      switch (originalAuthStatus) {
        case AuthStatus.noToken:
          Logger.root.fine("[UCStart checkTokenAndSetAccount] user not authenticated, skipping");
          return AuthStatus.noToken;
        case AuthStatus.accessExpired:
          await _authAPI.refresh();
          Logger.root.fine("[UCStart checkTokenAndSetAccount] user authenticated and token refreshed");
          userAccount = await _agentAPI.getCurrentUserAccount();
          Logger.root.fine('[UCStart checkTokenAndSetAccount] determined user account (after token refresh): ${userAccount.userId}');
        case AuthStatus.authenticated:
          userAccount = await _agentAPI.getCurrentUserAccount();
          Logger.root.fine('[UCStart checkTokenAndSetAccount] determined user account: ${userAccount.userId}');
      }
      return originalAuthStatus;
    } catch (e) {
      Logger.root.severe('[UCStart checkTokenAndSetAccount] error fetching user account: $e');
      _authAPI.logout();
      return AuthStatus.noToken;
    } finally {
      VMainPanelFactory.userAccount = userAccount;
      Logger.root.fine('[UCStart checkTokenAndSetAccount] user account set in VMainPanelFactory: ${VMainPanelFactory.userAccount?.userId}');
    }
  }
}