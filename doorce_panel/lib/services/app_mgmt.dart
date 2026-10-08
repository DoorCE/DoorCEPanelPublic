import 'dart:convert';

import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/default_app_template.dart';
import 'package:doorce_panel/dtos/source_creation_request.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:http/http.dart' as http;

abstract interface class AppManagementAPI {
  Future<List<XApp>> getAppList();
  Future<XApp> getApp(String identifier);
  Future<XAppTemplate> getAppTemplate(String identifier);
  Future<List<XAppTemplate>> getAppTemplateList();
  Future<http.Response> upsertApp(XApp app, List<XSourceCreationRequest> newResources, String? selectedCatalogueUri);
  Future<http.Response> upsertAppTemplate(XAppTemplate template);
  Future<http.Response> deleteApp(String identifier);
  Future<http.Response> deleteAppTemplate(String identifier);
  Future<bool> checkAppId(String identifier);
  Future<bool> checkAppTemplateId(String identifier);
  Future<XDefaultAppTemplate> getDefaultAppTemplate(String schemaId, String? conceptName);
  Future<http.Response> generateAppTemplate(String templateId);
  Future<http.Response> deployApp(String appId);
  Future<List<XApp>> getDatasetApps(String datasetUri);
  Future<XApp?> getDatasetDefaultApp(String datasetUri);
}

class AppManagement extends Api implements AppManagementAPI {

  AppManagement(AuthAPI authAPI) : super(authAPI);

  @override
  Future<List<XApp>> getAppList() async {
    final response = await httpGet('template/GetAppList');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XApp> apps = jsonList.map((json) {
        XApp app = XApp();
        app.fromJson(json as Map<String, dynamic>);
        if (app.sourceResourceUris.contains(app.activeResourceUri)) {
          app.isEnabled = true;
          app.isVisible = false;
          app.isDefault = true;
        }
        return app;
      }).toList();
      return apps;
    } else {
        throw Exception(
          'Error getting the apps - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XApp> getApp(String identifier) async {
    final response = await httpGet('template/GetApp?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final app = XApp();
      app.fromJson(jsonResponse);
      return app;
    } else {
      throw Exception(
          "Failed to fetch app with identifier: $identifier - status code: ${response.statusCode}");
    }
  }

  @override
  Future<XAppTemplate> getAppTemplate(String identifier) async {
    final response = await httpGet('template/GetAppTemplate?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final template = XAppTemplate();
      template.fromJson(jsonResponse);
      return template;
    } else {
      throw Exception(
          "Failed to fetch app template with identifier: $identifier - status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<XAppTemplate>> getAppTemplateList() async {
    final response = await httpGet('template/GetAppTemplateList');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XAppTemplate> templates = jsonList.map((json) {
        XAppTemplate template = XAppTemplate();
        template.fromJson(json as Map<String, dynamic>);
        return template;
      }).toList();
      return templates;
    } else {
        throw Exception(
          'Error getting the app templates - status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> upsertApp(XApp app, List<XSourceCreationRequest> newResources, String? sourceCatalogueUri) async {
    final body = jsonEncode({
      'newResources': newResources.map((r) => r.toJson()).toList(),
      'sourceCatalogueUri': sourceCatalogueUri,
      ...app.toJson(),
    });
    final response = await httpPost('template/UpsertApp', body);
    return response;
  }

  @override
  Future<http.Response> upsertAppTemplate(XAppTemplate template) async {
    final body = jsonEncode(template.toJson());
    final response = await httpPost('template/UpsertAppTemplate', body);
    return response;
  }

  @override
  Future<http.Response> deleteApp(String identifier) async {
    final response = await httpDelete('template/DeleteApp?appUri=$identifier');
    return response;
  }

  @override
  Future<http.Response> deleteAppTemplate(String identifier) async {
    final response = await httpDelete('template/DeleteAppTemplate?templateUri=$identifier');
    return response;
  }

  @override
  Future<bool> checkAppId(String identifier) async {
    final response = await httpGet('template/CheckAppId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkAppTemplateId(String identifier) async {
    final response = await httpGet('template/CheckAppTemplateId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XDefaultAppTemplate> getDefaultAppTemplate(String schemaId, String? conceptName) async {
    final response = await httpGet("template/GetDefaultAppTemplate?schemaId=$schemaId" + (null != conceptName ? "&conceptName=$conceptName" : ""));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final defaultTemplate = XDefaultAppTemplate();
      defaultTemplate.fromJson(jsonResponse);
      return defaultTemplate;
    } else {
      throw Exception(
          "Failed to fetch default app template - status code: ${response.statusCode}");
    }
  }

  @override
  Future<http.Response> generateAppTemplate(String templateId) async {
    final response = await httpPost("template/GenerateAppTemplate?templateUri=$templateId", null);
    return response;
  }

  @override
  Future<http.Response> deployApp(String appId) async {
    final response = await httpPost("template/DeployApp?appUri=$appId", null);
    return response;
  }

  @override
  Future<List<XApp>> getDatasetApps(String datasetUri) async {
    final response = await httpGet('template/GetDatasetApps?datasetUri=$datasetUri');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XApp> apps = jsonList.map((json) {
        XApp app = XApp();
        app.fromJson(json as Map<String, dynamic>);
        if (app.sourceResourceUris.contains(app.activeResourceUri)) {
          app.isDefault = true;
        }
        return app;
      }).toList();
      return apps;
    } else {
        throw Exception(
          'Error getting the dataset apps - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XApp?> getDatasetDefaultApp(String datasetUri) async {
    final response = await httpGet('template/GetDefaultDatasetApp?datasetUri=$datasetUri');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final app = XApp();
      app.fromJson(jsonResponse);
      app.isDefault = true; // Marking the app as default
      return app;
    } else if (response.statusCode == 204) {
      return null; // No default app found for the dataset
    } else {
      throw Exception(
          "Failed to fetch default app for dataset: $datasetUri - status code: ${response.statusCode}");
    }
  }
}