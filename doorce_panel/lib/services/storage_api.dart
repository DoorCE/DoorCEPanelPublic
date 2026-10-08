import 'dart:convert';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract interface class StorageAPI {
  Future<int?> deleteFile(int? identifier);
  Future<Uint8List?> getFile(int? identifier);
  Future<int> upsertFile(XFileData file);
}

class StorageManagement extends Api implements StorageAPI {

  StorageManagement(super.authApi);
   
  @override
  Future<int?> deleteFile(int? identifier) async {
    if (identifier == null) return null;
    
    final response = await httpDelete('storage/GetFile?identifier=$identifier');

    if (response.statusCode == 200) {
      return 0;
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception(
      'Error deleting the file with identifier: $identifier - status code: ${response.statusCode}');
  }
  
  @override
  Future<Uint8List?> getFile(int? identifier) async {
    if (null == identifier) return null;
    
    final response = await httpGet('storage/GetFile?identifier=$identifier');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception(
      'Error getting the file with identifier: $identifier - status code: ${response.statusCode}');
  }
  
  @override
  Future<int> upsertFile(XFileData file) async {
    final headers = await getUpsertHeaders();

    var request = http.MultipartRequest("POST",
          Uri.parse('$backendPath/storage/UpsertFile'));
    
    if (null != file.fileId){
      request.fields.addAll({'fileId': file.fileId.toString()});
    }
    request.fields.addAll({'fileName': file.fileName!});
    
    request.files.add(http.MultipartFile.fromBytes(
      'file', 
      file.content!,
      filename: file.fileName,
      contentType: MediaType.parse(file.contentType!)));
    request.headers.addAll(headers);

    http.Response response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      int result = jsonDecode(response.body);
      return result;
    } else {
      throw Exception("Error upserting file: ${response.statusCode}");
    }
  }
}