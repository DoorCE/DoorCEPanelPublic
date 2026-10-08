import 'package:doorce_panel/dtos/manageable_resource.dart';

class XSchemaSeries extends XManageableResource
{
  String title = '';
  String description = '';

  List<int> type = List<int>.empty(growable: true);
  String? currentSchemaUri;
  String? currentSchemaTitle;

  XSchemaSeries();
  XSchemaSeries.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = json['title'] ?? '';
    description = json['description'] ?? '';
    type = (json['type'] as List<dynamic>).map((e) => e as int).toList();
    currentSchemaUri = json['currentSchemaUri'];
    currentSchemaTitle = json['currentSchemaTitle'];
  }

  @override
  Map<String, dynamic> toJson() {
    var jsonData = {
      ...super.toJson(),
      'title': title,
      'description': description,
      'type': type,
      'currentSchemaUri': currentSchemaUri,
      'currentSchemaTitle': currentSchemaTitle,
    };
    return jsonData;
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), title];
  }
}