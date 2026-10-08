import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract class Api {
  String backendPath = const String.fromEnvironment("UDAS_SERVER_URL", defaultValue: "http://localhost:8081");
  
  AuthAPI _authAPI;

  Api(this._authAPI);

  Future<Map<String,String>> getCommonHeaders() async {
    final token = await _authAPI.getAccessToken();
    return {
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> getUpsertHeaders() async {
    final commonHeaders = await getCommonHeaders();
    return {
      ...commonHeaders,
      'Content-Type': 'application/json'
    };
  }

  Future<http.Response> httpGet(String urlPostfix) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.get(url, headers: await getCommonHeaders());
    if (response.statusCode == 401) {
      await _authAPI.refresh();
      response = await http.get(url, headers: await getCommonHeaders());
    }
    return response;
  }

  Future<http.Response> httpPost(String urlPostfix, String? body) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.post(url, headers: await getUpsertHeaders(), body: body);
    if (response.statusCode == 401) {
      await _authAPI.refresh();
      response = await http.post(url, headers: await getUpsertHeaders(), body: body);
    }
    return response;
  }

  Future<http.Response> _sendMultipart(Uri url, String requestBody, XFileData? file) async {
    // TODO - make it usable for storage/icon api?

    var request = http.MultipartRequest("POST", url);

    request.fields.addAll({"request": requestBody});

    if (file != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        file.content!,
        filename: file.fileName,
        contentType: MediaType.parse(file.contentType ?? "application/octet-stream"),
      ));
    }

    request.headers.addAll(await getUpsertHeaders());
    return await http.Response.fromStream(await request.send());

  }

  Future <http.Response> httpMultipart(String urlPostfix, String requestBody, XFileData? file) async {
    final url = Uri.parse("$backendPath/$urlPostfix");

    http.Response response = await _sendMultipart(url, requestBody, file);

    if (response.statusCode == 401) {
      await _authAPI.refresh();
      response = await _sendMultipart(url, requestBody, file);
    }

    return response;
  }

  Future<http.Response> httpDelete(String urlPostfix) async {
    final url = Uri.parse("$backendPath/$urlPostfix");
    http.Response response = await http.delete(url, headers: await getCommonHeaders());
    if (response.statusCode == 401) {
      await _authAPI.refresh();
      response = await http.delete(url, headers: await getCommonHeaders());
    }
    return response;
  }
}