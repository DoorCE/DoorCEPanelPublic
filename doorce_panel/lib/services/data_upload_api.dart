import 'dart:convert';
import 'package:doorce_panel/dtos/data_upload_request.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:http/http.dart' as http;

abstract interface class DataUploadAPI {
  Future<http.Response> deleteData(String datasetUri);
  Future<http.Response> upsertData(XFileData? file, XDataUploadRequest request);
  Future<Map<String, int>> getDataItemCounts(String datasetUri);
}

class DataUpload extends Api implements DataUploadAPI {

  DataUpload(super.authApi);
   
  @override
  Future<http.Response> deleteData(String datasetUri) async {
    final response = await httpDelete('upload/ClearDataItemsByDatasetUri?datasetUri=$datasetUri');

    return response;
  }
  
  @override
  Future<http.Response> upsertData(XFileData? file, XDataUploadRequest dataUploadRequest) async {
    final jsonData = dataUploadRequest.toJson();

    return await httpMultipart('upload/UploadData', jsonEncode(jsonData), file);
  }

  @override
  Future<Map<String, int>> getDataItemCounts(String datasetUri) async {
    final response = await httpGet('upload/GetDataItemCountsByConcept?datasetUri=$datasetUri');

    if (response.statusCode == 200) {
      final Map<String,dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((key, value) => MapEntry(key, value as int));
    } else {
        throw Exception(
          'Error getting the data item counts for datasetUri: $datasetUri - status code: ${response.statusCode}');
    }
  }
}