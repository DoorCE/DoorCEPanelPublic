import 'dart:convert';
import 'package:doorce_panel/dtos/icon_data.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract interface class IconAPI {
  Future<int> deleteIcon(String identifier);
  Future<Uint8List?> getIcon(String? identifier);
  Future<int> upsertIcon(XIconData data, Uint8List icon);
  Future<List<XIconData>> getIconList(String query);
}

class IconManagement extends Api implements IconAPI {

  IconManagement(super.authApi);
 
  @override
  Future<int> deleteIcon(String identifier) {
    // TODO: implement deleteIcon
    throw UnimplementedError();
  }
  
  @override
  Future<Uint8List?> getIcon(String? identifier) async {
    if (null == identifier || identifier.isEmpty) return null;
    
    final response = await httpGet('storage/GetIcon?identifier=$identifier');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    }
    if (response.statusCode == 404) {
      return null;
    }
    throw Exception(
      'Error getting the icon with identifier: $identifier - status code: ${response.statusCode}');
  }
  
  @override
  Future<List<XIconData>> getIconList(String query) async {
    final response = await httpGet('storage/GetIconList?identifier=$query');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XIconData icon = XIconData();
        icon.fromJson(json as Map<String, dynamic>);
        return icon;
      }).toList();
    } else {
      throw Exception('Error getting the icons with query: $query - status code: ${response.statusCode}');
    }
  }
  
  @override
  Future<int> upsertIcon(XIconData data, Uint8List icon) async {
    final headers = await getUpsertHeaders();

    var request = http.MultipartRequest("POST",
          Uri.parse('$backendPath/storage/UpsertIcon'));
    request.fields.addAll({'iconUri': data.iconUri!, 'iconName': data.iconName!});
    request.files.add(http.MultipartFile.fromBytes('file',icon, filename: "${data.iconName}.png", contentType: MediaType('image','png')));
    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      return 0;
    } else {
      throw Exception("Error updating icon: ${response.statusCode}");
    }
  }
}
