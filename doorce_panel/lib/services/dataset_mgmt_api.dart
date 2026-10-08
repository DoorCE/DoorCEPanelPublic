import 'dart:convert';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/data_resource.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/ckan_result.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract interface class DatasetManagementAPI {
  Future<bool> checkCatalogueId(String identifier);
  Future<bool> checkDatasetId(String identifier);
  Future<bool> checkSeriesId(String identifier);
  Future<bool> checkDataServiceId(String identifier);
  Future<bool> checkDistributionId(String identifier);
  Future<http.Response> deleteCatalogue(String identifier);
  Future<http.Response> deleteSeries(String identifier);
  Future<http.Response> deleteDataset(String identifier);
  Future<http.Response> deleteService(String identifier);
  Future<int> setDatasetSchema(String datasetID, String schemaID);

  Future<XCatalogue> getCatalog(String? identifier);
  Future<XDataset> getDataset(String identifier);
  Future<XDatasetSeries> getSeries(String identifier);
  Future<XDatasetService> getDataService(String identifier);

  Future<http.Response> upsertCatalogue(XCatalogue catalogue, List<XContactData> newContacts);
  Future<http.Response> upsertDataset(XDataset dataset, List<XContactData> newContacts, {bool addApp = false});
  Future<XCkanResult> publishDataset(BuildContext context, String identifier, {bool withData = false});
  Future<XCkanResult> unpublishDataset(BuildContext context, String identifier);
  Future<http.Response> upsertSeries(XDatasetSeries datasetSeries, List<XContactData> newContacts);
  Future<http.Response> upsertService(XDatasetService datasetServices, List<XContactData> newContacts);

  Future<List<XCatalogue>> getCataloguesInCatalogue(String? identifier);
  Future<List<XDataset>> getDatasetsInCatalogue(String? identifier);
  Future<List<XDatasetSeries>> getSeriesInCatalogue(String? identifier);
  Future<List<XDatasetService>> getServicesInCatalogue(String? identifier);
  Future<List<XCatalogue>> getAllowedCatalogues(String? identifier);
  Future<List<XDatasetSeries>> getAllowedSeries(String? indentifier);
  Future<List<XDatasetService>> getAllowedServices(String? indentifier);
  Future<List<XDataset>> getAllowedDatasets(String? identifier);

  Future<List<XContactData>> getMultipleAgentContacts(List<String> agentIds);

  Future<List<XDataset>> getSeriesDatasetList(String identifier);
  Future<List<XDistribution>> getServicesContents(String identifier);

  Future<List<XDistribution>> getDatasetDistributionList(String identifier);
  Future<List<XDistribution>> getDataserviceDistributionList(String identifier);
  Future<XDistribution> getDistribution(String identifier);
  Future<http.Response> upsertDistribution(XDistribution distribution);
  Future<http.Response> deleteDistribution(String identifier);
  Future<List<XDataResource>> getManagedDataResources(String? identifier);
  Future<List<XDataset>> getSchemaDatasets(String? schemaID);
}

class DatasetManagement extends Api implements DatasetManagementAPI {

  IconAPI _iconAPI;

  DatasetManagement(this._iconAPI, AuthAPI authAPI) : super(authAPI);

  @override
  Future<bool> checkCatalogueId(String identifier) async {
    final response = await httpGet('datasets/CheckCatalogueId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkDatasetId(String identifier) async {
    final response = await httpGet('datasets/CheckDatasetId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkSeriesId(String identifier) async {
    final response = await httpGet('datasets/CheckSeriesId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkDataServiceId(String identifier) async {
    final response = await httpGet('distributions/CheckDataServiceId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkDistributionId(String identifier) async {
    final response = await httpGet('distributions/CheckDistributionId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> deleteCatalogue(String identifier) async {
    final response = await httpDelete('datasets/DeleteCatalogue?identifier=$identifier');
    return response;
  }

  @override
  Future<http.Response> deleteSeries(String identifier) async {
    final response = await httpDelete('datasets/DeleteSeries?identifier=$identifier');

    return response;
  }

  @override
  Future<http.Response> deleteDataset(String identifier) async {
    final response = await httpDelete('datasets/DeleteDataset?identifier=$identifier');

    return response;
  }

  @override
  Future<http.Response> deleteService(String identifier) async {
    final response = await httpDelete('distributions/DeleteDataService?identifier=$identifier');

    return response;
  }

  @override
  Future<int> setDatasetSchema(String datasetID, String schemaID) async {
    return 0;
  }

  @override
  Future<http.Response> upsertCatalogue(XCatalogue catalogue, List<XContactData> newContacts) async {
    final body = jsonEncode({
      'catalogue': catalogue.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('datasets/UpsertCatalogue', body);
    return response;
  }

  @override
  Future<http.Response> upsertDataset(XDataset dataset, List<XContactData> newContacts, {bool addApp = false}) async {
    final body = jsonEncode({
      'dataset': dataset.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('datasets/UpsertDataset${addApp ? '?addApp=true' : ""}', body);
    return response;
  }

  @override
  Future<XCkanResult> publishDataset(BuildContext context, String identifier, {bool withData = false}) async{
    final response = await httpPost('datasets/PublishDataset?identifier=$identifier&withData=$withData', null);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XCkanResult result = XCkanResult();
      result.fromJson(jsonData);
      return result;
    } else if (response.statusCode == 403) {
      throw Exception(AppLocalizations.of(context)!.authError);
    } else {
        throw Exception(
          'Error publishing the dataset with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XCkanResult> unpublishDataset(BuildContext context, String identifier) async {
    final response = await httpDelete('datasets/UnpublishDataset?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XCkanResult result = XCkanResult();
      result.fromJson(jsonData);
      return result;
    } else if (response.statusCode == 403) {
      throw Exception(AppLocalizations.of(context)!.authError);
    } else {
        throw Exception(
          'Error publishing the dataset with identifier: $identifier - status code: ${response.statusCode}');
    }
  }


  @override
  Future<http.Response> upsertSeries(XDatasetSeries datasetSeries, List<XContactData> newContacts) async {
    final body = jsonEncode({
      'datasetSeries': datasetSeries.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('datasets/UpsertSeries', body);

    return response;
  }

  @override
  Future<http.Response> upsertService(XDatasetService datasetService, List<XContactData> newContacts) async {
    final body = jsonEncode({
      'dataService': datasetService.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('distributions/UpsertDataService', body);

    return response;
  }

  @override
  Future<XCatalogue> getCatalog(String? identifier) async {
    final response = await httpGet('datasets/GetCatalogue' + (null != identifier ? '?identifier=$identifier' : ''));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XCatalogue catalogue = XCatalogue();
      catalogue.fromJson(jsonData);
      catalogue.icon = await _iconAPI.getIcon(catalogue.iconUri);
      return catalogue;
    } else {
        throw Exception(
          'Error getting the catalogue with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XDataset> getDataset(String identifier) async {
    final response = await httpGet('datasets/GetDataset?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XDataset dataset = XDataset();
      dataset.fromJson(jsonData);
      dataset.icon = await _iconAPI.getIcon(dataset.iconUri);
      return dataset;
    } else {
        throw Exception(
          'Error getting the dataset with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XDatasetSeries> getSeries(String identifier) async {
    final response = await httpGet('datasets/GetSeries?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XDatasetSeries datasetSeries = XDatasetSeries();
      datasetSeries.fromJson(jsonData);
      datasetSeries.icon = await _iconAPI.getIcon(datasetSeries.iconUri);
      return datasetSeries;
    } else {
        throw Exception(
          'Error getting the series with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XDatasetService> getDataService(String identifier) async {
    final response = await httpGet('distributions/GetDataService?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XDatasetService datasetService = XDatasetService();
      datasetService.fromJson(jsonData);
      datasetService.icon = await _iconAPI.getIcon(datasetService.iconUri);
      return datasetService;
    } else {
        throw Exception(
          'Error getting the data service with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XCatalogue>> getCataloguesInCatalogue(String? identifier) async {
    final response = await httpGet('datasets/GetCataloguesInCatalogue${null != identifier ? "?identifier=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XCatalogue> catalogues = jsonList.map((json) {
        XCatalogue catalogue = XCatalogue();
        catalogue.fromJson(json as Map<String, dynamic>);
        return catalogue;
      }).toList();
      for (var catalogue in catalogues) {
        catalogue.icon = await _iconAPI.getIcon(catalogue.iconUri);
      }
      return catalogues;
    } else {
        throw Exception(
          'Error getting the catalogues in catalogue with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDataset>> getDatasetsInCatalogue(String? identifier) async {
    final response = await httpGet('datasets/GetDatasetsInCatalogue${null != identifier ? "?identifier=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDataset> datasets = jsonList.map((json) {
        XDataset dataset = XDataset();
        dataset.fromJson(json as Map<String, dynamic>);
        return dataset;
      }).toList();
      for (var dataset in datasets) {
        dataset.icon = await _iconAPI.getIcon(dataset.iconUri);
      }
      return datasets;
    } else {
        throw Exception(
          'Error getting the datasets in catalogue with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDatasetSeries>> getSeriesInCatalogue(String? identifier) async {
    final response = await httpGet('datasets/GetSeriesInCatalogue${null != identifier ? "?identifier=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDatasetSeries> seriesList = jsonList.map((json) {
        XDatasetSeries series = XDatasetSeries();
        series.fromJson(json as Map<String, dynamic>);
        return series;
      }).toList();
      for (var series in seriesList) {
        series.icon = await _iconAPI.getIcon(series.iconUri);
      }
      return seriesList;
    } else {
        throw Exception(
          'Error getting the series in catalogue with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDatasetService>> getServicesInCatalogue(String? identifier) async {
    final response = await httpGet('datasets/GetServicesInCatalogue${null != identifier ? "?identifier=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDatasetService> services = jsonList.map((json) {
        XDatasetService service = XDatasetService();
        service.fromJson(json as Map<String, dynamic>);
        return service;
      }).toList();
      for (var service in services) {
        service.icon = await _iconAPI.getIcon(service.iconUri);
      }
      return services;
    } else {
        throw Exception(
          'Error getting the service in catalogue with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDataset>> getSeriesDatasetList(String identifier) async {
    final response = await httpGet('datasets/GetSeriesDatasetList?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDataset> datasets = jsonList.map((json) {
        XDataset dataset = XDataset();
        dataset.fromJson(json as Map<String, dynamic>);
        return dataset;
      }).toList();
      for (XDataset dataset in datasets) {
        dataset.icon = await _iconAPI.getIcon(dataset.iconUri);
      }
      return datasets;
    } else {
        throw Exception(
          'Error getting the datasets in series with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDistribution>> getServicesContents(String identifier) async {
    final response = await httpGet('distributions/GetServiceDistributionList?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDistribution> distributions = jsonList.map((json) {
        XDistribution distribution = XDistribution();
        distribution.fromJson(json as Map<String, dynamic>);
        return distribution;
      }).toList();
      for (XDistribution distribution in distributions) {
        distribution.icon = await _iconAPI.getIcon(distribution.datasetIconUri);
      }
      return distributions;
    } else {
        throw Exception(
          'Error getting the distribution in services with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDataResource>> getManagedDataResources(String? identifier) async {
    final response = await httpGet('datasets/GetManagedDataResources');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<XDataResource> resourcesList = [];
      jsonData.forEach((key, value) {
        List<XDataResource> resources = (value as List<dynamic>).map((item) {
          var resource = key == 'datasets' ? XDataset() : XDatasetSeries();
          resource.fromJson(item as Map<String, dynamic>);
          return resource;
        }).toList();
        resourcesList.addAll(resources);
      });
        for (XDataResource resource in resourcesList) {
          resource.icon = await _iconAPI.getIcon(resource.iconUri);
        }
      return resourcesList;
    } else {
        throw Exception(
          'Error getting the agent data resources with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XCatalogue>> getAllowedCatalogues(String? identifier) async {
    final response = await httpGet('datasets/GetAllowedCatalogues${null != identifier ? "?resourceId=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XCatalogue> catalogues = jsonList.map((json) {
        XCatalogue catalogue = XCatalogue();
        catalogue.fromJson(json as Map<String, dynamic>);
        return catalogue;
      }).toList();
      for (XCatalogue catalogue in catalogues) {
        catalogue.icon = await _iconAPI.getIcon(catalogue.iconUri);
      }
      return catalogues;
    } else {
        throw Exception(
          'Error getting the agent catalogues with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDistribution>> getDatasetDistributionList(String identifier) async {
    final response = await httpGet('distributions/GetDatasetDistributionList?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDistribution> distributions = jsonList.map((json) {
        XDistribution distribution = XDistribution();
        distribution.fromJson(json as Map<String, dynamic>);
        return distribution;
      }).toList();
      for (XDistribution distribution in distributions) {
        distribution.icon = await _iconAPI.getIcon(distribution.datasetIconUri);
      }
      return distributions;
    } else {
        throw Exception(
          'Error getting the distribution of the dataset with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XDistribution> getDistribution(String identifier) async {
    final response = await httpGet('distributions/GetDistribution?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      XDistribution distribution = XDistribution();
      distribution.fromJson(jsonData);
      distribution.icon = await _iconAPI.getIcon(distribution.datasetIconUri);
      return distribution;
    } else {
        throw Exception(
          'Error getting the distribution with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> upsertDistribution(XDistribution distribution) async {
    final body = jsonEncode(distribution.toJson());

    final response = await httpPost('distributions/UpsertDistribution', body);
    return response;
  }

  @override
  Future<List<XDatasetSeries>> getAllowedSeries(String? identifier) async {
    final response = await httpGet('datasets/GetAllowedSeries${null != identifier ? "?datasetId=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDatasetSeries> seriesList = jsonList.map((json) {
        XDatasetSeries series = XDatasetSeries();
        series.fromJson(json as Map<String, dynamic>);
        return series;
      }).toList();
      for (XDatasetSeries series in seriesList) {
        series.icon = await _iconAPI.getIcon(series.iconUri);
      }
      return seriesList;
    } else {
        throw Exception(
          'Error getting the agent series with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XContactData>> getMultipleAgentContacts(List<String> agentIds) async {
    if (agentIds.isEmpty) return [];
    final body = jsonEncode(agentIds);

    final response = await httpPost('agents/GetMultipleAgentContacts', body);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XContactData contact = XContactData();
        contact.fromJson(json as Map<String, dynamic>);
        return contact;
      }).toList();
    } else {
        throw Exception(
          'Error getting contacts for agents: ${agentIds.join(", ")} - status code: ${response.statusCode}');
    }
  }



  @override
  Future<List<XDataset>> getAllowedDatasets(String? identifier) async {
    final response = await httpGet('datasets/GetAllowedDatasets${null != identifier ? "?distributionId=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDataset> datasets = jsonList.map((json) {
        XDataset dataset = XDataset();
        dataset.fromJson(json as Map<String, dynamic>);
        return dataset;
      }).toList();
      for (XDataset dataset in datasets) {
        dataset.icon = await _iconAPI.getIcon(dataset.iconUri);
      }
      return datasets;
    } else {
        throw Exception(
          'Error getting the agent datasets with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDistribution>> getDataserviceDistributionList(String identifier) async {
    final response = await httpGet('distributions/GetServiceDistributionList?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDistribution> distributions = jsonList.map((json) {
        XDistribution distribution = XDistribution();
        distribution.fromJson(json as Map<String, dynamic>);
        return distribution;
      }).toList();
      for (XDistribution distribution in distributions) {
        distribution.icon = await _iconAPI.getIcon(distribution.datasetIconUri);
      }
      return distributions;
    } else {
      throw Exception(
          'Error getting the distributions of dataservice with identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XDatasetService>> getAllowedServices(String? identifier) async {
    final response = await httpGet('datasets/GetAllowedServices${null != identifier ? "?distributionId=$identifier" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDatasetService> services = jsonList.map((json) {
        XDatasetService service = XDatasetService();
        service.fromJson(json as Map<String, dynamic>);
        return service;
      }).toList();
      for (XDatasetService service in services) {
        service.icon = await _iconAPI.getIcon(service.iconUri);
      }
      return services;
    } else {
        throw Exception(
          'Error getting the agent dataservices with identifier: $identifier - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<http.Response> deleteDistribution(String identifier) async {
    final response = await httpDelete('distributions/DeleteDistribution?identifier=$identifier');

    return response;
  }

  @override
  Future<List<XDataset>> getSchemaDatasets(String? schemaID) async {
    final response = await httpGet('datasets/GetSchemaDatasets${null != schemaID ? "?schemaUri=$schemaID" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      List<XDataset> datasets = jsonList.map((json) {
        XDataset dataset = XDataset();
        dataset.fromJson(json as Map<String, dynamic>);
        return dataset;
      }).toList();
      return datasets;
    } else {
        throw Exception(
          'Error getting the datasets for schema with identifier: $schemaID - status code: ${response.statusCode}');
    }
  }
}