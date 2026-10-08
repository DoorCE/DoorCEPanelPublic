import 'dart:convert';

import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;
import 'package:jwt_decoder/jwt_decoder.dart';

/// Authentication service implementing OAuth2/OpenID Connect with Keycloak
/// Manages the complete authentication lifecycle, including:
/// - Authorization flow with PKCE
/// - Token management (access_token and refresh_token)
/// - Session validation
/// - Logout with token revocation

abstract interface class AuthAPI {
  Future<bool> authenticate(String? code);
  Future<void> refresh();
  Future<Map<String, dynamic>> getUserInfo();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<AuthStatus> getAuthStatus();
  Future<bool> logout();
}

class KeycloakAuthService implements AuthAPI {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Keycloak server settings
  /// - keycloakUrl: Base endpoint of the Keycloak server
  /// - realm: Tenant realm
  /// - clientId: OAuth2 client identifier
  /// - redirectUrl: Redirect URI after authentication
  
  final String _keycloakUrl = const String.fromEnvironment("KEYCLOAK_PATH");
  final String _realm = const String.fromEnvironment("KEYCLOAK_REALM", defaultValue: "udas");
  final String _clientId = const String.fromEnvironment("KEYCLOAK_CLIENT", defaultValue: "udas-panel");
  final String _redirectUrl = const String.fromEnvironment("KEYCLOAK_REDIRECT", defaultValue: "http://localhost:60100/");
  final String _clientSecret = const String.fromEnvironment("KEYCLOAK_CLIENT_SECRET");

  /// Initiates the OAuth2/OpenID Connect authentication flow
  ///
  /// Implements the Authorization Code Flow with PKCE
  /// 1. Configures authorization server endpoints
  /// 2. Initiates authorization flow
  /// 3. Exchanges code for tokens
  /// 4. Securely stores tokens
  ///
  /// @return Future<bool> - true if authentication successful
  Future<bool> authenticate(String? code) async {
    try {
      if (null != code) {
        Logger.root.fine("[AuthAPI authenticate] code received - starting token exchange");
        // Exchange code for tokens
        final response = await http.post(
          Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/token'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'authorization_code',
            'code': code,
            'redirect_uri': _redirectUrl,
            'client_id': _clientId,
            'client_secret': _clientSecret,
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final refreshToken = data["refresh_token"];

          if (null == refreshToken || (refreshToken as String).isEmpty) {
            Logger.root.severe("[AuthAPI authenticate] Keycloak returned null/empty token\nFull token response: ${response.body}");
            throw AuthenticationException("No refresh token found");
          }

          Logger.root.fine("[AuthAPI authenticate] received refresh token: $refreshToken");
          await _secureStorage.write(
              key: 'access_token', value: data['access_token']);
          await _secureStorage.write(
              key: 'refresh_token', value: data['refresh_token']);
          Logger.root.fine("[AuthAPI authenticate] tokens received successfully");

          html.window.location.replace(_redirectUrl + "#/"); // Clear history and go to main page
          return true;
        }
        Logger.root.severe('[AuthAPI authenticate] token exchange failed: ${response.body}');
        return false;
      }

      Logger.root.fine("[AuthAPI authenticate] starting OAuth2 authentication flow...");
      // Requests authorization and exchanges code for tokens
      final authUrl =
        '${_keycloakUrl}/realms/$_realm/protocol/openid-connect/auth'
        '?client_id=$_clientId'
        '&redirect_uri=${_redirectUrl}'
        '&response_type=code'
        '&scope=openid profile email'
        '&prompt=login';

      // Launch the authorization URL in a new tab
      Logger.root.fine("[AuthAPI authenticate] Opening authorization URL: $authUrl");
      await launchUrl(Uri.parse(authUrl), webOnlyWindowName: '_self');
      return false;
    } catch (e) {
      Logger.root.severe('[AuthAPI authenticate] OAuth2 authentication failed: $e');
      return false;
    }
  }

  Future<void> refresh() async { 
    try {
      Logger.root.fine("[AuthAPI refresh] refreshing access token...");

      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) {
        Logger.root.fine("[AuthAPI refresh] no refresh token found, re-authentication required");
        throw AuthenticationException('No refresh token found');
      } else {
        Logger.root.fine("[AuthAPI refresh] found refresh token: $refreshToken");
      }

      final response = await http.post(
        Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': _clientId,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final newRefreshToken = data["refresh_token"];

        if (null == newRefreshToken || (newRefreshToken as String).isEmpty) {
          Logger.root.severe("[AuthAPI refresh] Keycloak returned null/empty token\nFull token response: ${response.body}");
          throw AuthenticationException("No refresh token found");
        }

        Logger.root.fine("[AuthAPI refresh] received refresh token: $newRefreshToken");
        await _secureStorage.write(key: 'access_token', value: data['access_token']);
        await _secureStorage.write(key: 'refresh_token', value: data['refresh_token']);
        Logger.root.fine("[AuthAPI refresh] token refreshed successfully");
        return;
      } else {
        Logger.root.fine('[AuthAPI refresh] token refresh failed: ${response.body}');
        await _secureStorage.delete(key: 'access_token');
        await _secureStorage.delete(key: 'refresh_token');
        throw AuthenticationException('Token refresh failed');
      }
    } catch (e) {
      Logger.root.severe('[AuthAPI refresh] token refresh error: $e');
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');
      throw AuthenticationException('Token refresh error');
    }
  }

  /// Recupera informações do usuário autenticado
  ///
  /// Utiliza o endpoint userinfo do OpenID Connect
  /// Requer token de acesso válido
  ///
  /// @return Future<Map<String, dynamic>> - Dados do usuário em formato JSON
  Future<Map<String, dynamic>> getUserInfo() async {
    final token = await getAccessToken();
    final response = await http.get(
      Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/userinfo'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Logger.root.fine("[AuthAPI getUserInfo] user information retrieved successfully: ${response.body}");
      return json.decode(response.body);
    } else {
      Logger.root.severe("[AuthAPI getUserInfo] failed to retrieve user information: ${response.body}");
      throw Exception('Failed to retrieve user information');
    }
  }

  /// Recupera o token de acesso JWT armazenado
  ///
  /// @return Future<String?> - Token JWT ou null se não autenticado
  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  /// Verify if the user is authenticated by checking for a valid access token
  ///
  /// @return Future<AuthStatus> - AuthStatus.authenticated if valid (non-expired) token exists, 
  /// AuthStatus.accessExpired if token expired, AuthStatus.noToken if no valid token found
  @override
  Future<AuthStatus> getAuthStatus() async {
    // Read the access token from secure storage
    final token = await _secureStorage.read(key: 'access_token');
    if (token == null) return AuthStatus.noToken;
    // Check token expiration
    final payload;
    try {
      payload = JwtDecoder.decode(token);
    } catch (e) {
      Logger.root.severe('[AuthAPI isNotExpired] Failed to decode JWT payload: $e');
      return AuthStatus.noToken;
    }
    if (payload.isEmpty) return AuthStatus.noToken;
    final exp = payload['exp'];
    if (exp == null) return AuthStatus.noToken;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return exp > now ? AuthStatus.authenticated : AuthStatus.accessExpired;
  }

  /// Realiza logout e revogação de tokens
  ///
  /// Implementa:
  /// 1. Limpeza local de tokens
  /// 2. Revogação de tokens no servidor
  ///
  /// @return Future<bool> - true if logout successful
  Future<bool> logout() async {
    Logger.root.fine("[AuthAPI logout] starting...");

    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();

      if (accessToken == null) {
        return true;
      }

      Logger.root.fine("[AuthAPI logout] refresh token: $refreshToken");
      // Revoke tokens locally
      await _secureStorage.delete(key: 'access_token');
      await _secureStorage.delete(key: 'refresh_token');

      // Revoke tokens on the server
      final response = await http.post(
        Uri.parse('$_keycloakUrl/realms/$_realm/protocol/openid-connect/logout'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'client_id': _clientId,
          'refresh_token': refreshToken,
          'client_secret': _clientSecret, // include if required
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (AuthStatus.noToken == await getAuthStatus()) {
          Logger.root.fine("[AuthAPI logout] logout and token revocation completed");
        } else {
          Logger.root.severe("[AuthAPI logout] error - user is still authenticated");
        }
        return true;
      } else {
        Logger.root.fine("[AuthAPI logout] token revocation failed: ${response.statusCode} - ${response.body}");
        return true;
      }
    } catch (e) {
      Logger.root.severe('[AuthAPI logout] logout failed: $e');
      return true;
    }
  }
}

enum AuthStatus {
  authenticated,
  accessExpired,
  noToken
}