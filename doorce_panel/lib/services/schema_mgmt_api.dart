import 'dart:convert';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/namespace.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:http/http.dart' as http;

abstract interface class SchemaAPI {
  Future<bool> checkSchemaId(String identifier);
  Future<bool> checkSchemaSeriesId(String identifier);
  Future<XSchemaSeries> getSchemaSeries(String identifier);
	Future<List<XSchemaSeries>> getSchemaSeriesList(String query);
	Future<http.Response> upsertSchemaSeries(XSchemaSeries series);
	Future<http.Response> deleteSchemaSeries(String identifier);
	Future<List<XDataSchema>> getDataSchemaList(String? query);
	Future<List<XDataSchema>> getSeriesDataSchemaList(String seriesIdentifier);
  Future<List<XSchemaSeries>> getAllowedSchemaSeries(String schemaId);
	Future<XDataSchema> getDataSchema(String identifier);
	Future<http.Response> upsertDataSchema(XDataSchema schema);
	Future<http.Response> deleteDataSchema(String identifier);
  Future<List<XNamespace>> getStandardNamespaces();

	// Future<List<XSchemaTransformation>> getTransformationList(String query);
	// Future<int> upsertTransformation(XSchemaTransformation transformation);
	// Future<int> deleteTransformation(String identifier);
}

class SchemaManagement extends Api implements SchemaAPI {

  SchemaManagement(super.authAPI);

  @override
  Future<bool> checkSchemaId(String identifier) async {
    final response = await httpGet('schemas/CheckSchemaId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<bool> checkSchemaSeriesId(String identifier) async {
    final response = await httpGet('schemas/CheckSchemaSeriesId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<http.Response> deleteDataSchema(String identifier) {
    return httpDelete('schemas/DeleteDataSchema?identifier=$identifier').then((response) {
      return response;
    });
  }
  
  @override
  Future<http.Response> deleteSchemaSeries(String identifier) {
    return httpDelete('schemas/DeleteSchemaSeries?identifier=$identifier').then((response) {
      return response;
    });
  }
  
  @override
  Future<XDataSchema> getDataSchema(String identifier) {
    return httpGet('schemas/GetDataSchema?identifier=$identifier').then((response) {
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final schema = XDataSchema();
        schema.fromJson(jsonResponse);
        return schema;
      } else {
        throw Exception(
            "Failed to fetch schema with identifier: $identifier - status code: ${response.statusCode}");
      }
    });
  }
  
  @override
  Future<List<XDataSchema>> getDataSchemaList(String? query) async {
    final response = await httpGet('schemas/GetDataSchemaList${null != query ? "?query=$query" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XDataSchema schema = XDataSchema();
        schema.fromJson(json as Map<String, dynamic>);
        return schema;
      }).toList();
    } else {
      throw Exception(
          'Error getting schemas with query: $query - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<XSchemaSeries> getSchemaSeries(String identifier) async {
    final response = await httpGet('schemas/GetSchemaSeries?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final series = XSchemaSeries();
      series.fromJson(jsonResponse);
      return series;
    } else {
      throw Exception(
          "Failed to fetch series with identifier: $identifier - status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<XSchemaSeries>> getAllowedSchemaSeries(String schemaId) async {
    final response = await httpGet('schemas/GetAllowedSchemaSeries?schemaId=$schemaId');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XSchemaSeries schema = XSchemaSeries();
        schema.fromJson(json as Map<String, dynamic>);
        return schema;
      }).toList();
    } else {
      throw Exception(
          'Error getting series with query: $schemaId - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<List<XSchemaSeries>> getSchemaSeriesList(String query) async {
    final response = await httpGet('schemas/GetSchemaSeriesList?query="$query"');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XSchemaSeries schema = XSchemaSeries();
        schema.fromJson(json as Map<String, dynamic>);
        return schema;
      }).toList();
    } else {
      throw Exception(
          'Error getting series with query: $query - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<List<XDataSchema>> getSeriesDataSchemaList(String seriesIdentifier) {
    return httpGet('schemas/GetSeriesDataSchemaList?seriesIdentifier=$seriesIdentifier').then((response) {
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

        return jsonList.map((json) {
          XDataSchema schema = XDataSchema();
          schema.fromJson(json as Map<String, dynamic>);
          return schema;
        }).toList();
      } else {
        throw Exception(
            'Error getting series data schemas - status code: ${response.statusCode}');
      }
    });
  }
  
  @override
  Future<http.Response> upsertDataSchema(XDataSchema schema) async{
    final body = jsonEncode(schema.toJson());

    final response = await httpPost('schemas/UpsertDataSchema', body);
    return response;
  }
  
  @override
  Future<http.Response> upsertSchemaSeries(XSchemaSeries series) async {
    final body = jsonEncode(series.toJson());

    final response = await httpPost('schemas/UpsertSchemaSeries', body);
    return response;
  }

  @override
  Future<List<XNamespace>> getStandardNamespaces() async {
    final response = await httpGet('schemas/GetStandardNamespaceList');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XNamespace namespace = XNamespace();
        namespace.fromJson(json as Map<String, dynamic>);
        return namespace;
      }).toList();
    } else {
      throw Exception(
          'Error getting standard namespaces - status code: ${response.statusCode}');
    }
  }  

}