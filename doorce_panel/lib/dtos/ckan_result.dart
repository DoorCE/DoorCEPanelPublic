import 'package:universal_html/html.dart';

class XCkanResult {
  bool isSuccess = true;
  int statusCode = HttpStatus.ok;
  List<Map<String, dynamic>> results = [];
  Map<String, dynamic>? details;
  String? errorMessage;
  Map<String, int>? upsertedRows;

  XCkanResult();

  void fromJson(Map<String, dynamic> json) {
    isSuccess = json["isSuccess"] ?? false;
    statusCode = json["statusCode"] ?? HttpStatus.badRequest;
    results = List.from(json["results"] ?? []);
    details = Map.from(json["details"] ?? {});
    errorMessage = json["errorMessage"] ?? null;
    upsertedRows = Map.from(json["upsertedRows"] ?? {});
  }

  Map<String, int> toJson() {
    throw new UnimplementedError();
  }
}