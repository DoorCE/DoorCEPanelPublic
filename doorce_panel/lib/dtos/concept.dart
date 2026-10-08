import 'package:doorce_panel/dtos/namespace_element.dart';
import 'package:doorce_panel/dtos/property.dart';

class XConcept extends XNamespaceElement
{
  String uid = "";
  String type = 'object';
  List<XProperty> properties = <XProperty>[];
  String description = "";
  List<XProperty> required = <XProperty>[];
  List<XProperty> unique = <XProperty>[];
  XProperty? defaultIdentifier;

  XConcept() {
    uid = DateTime.now().microsecondsSinceEpoch.toString();
  }

  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    type = json['type'] ?? 'object';
    description = json['description'] ?? '';
    properties = <XProperty>[];
    final propsMap = (json['properties'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    propsMap.forEach((k, v) {
      final p = XProperty();
      p.fromJson(name, k, v as Map<String, dynamic>);
      properties.add(p);
    });

    var jsonRequired = json['required'] as List<dynamic>? ?? [];
    var jsonUnique = json['unique'] as List<dynamic>? ?? [];

    required = jsonRequired.isNotEmpty
        ? jsonRequired.map((e) => properties.firstWhere((p) => p.name == e.toString())).toList()
        : <XProperty>[];
    unique = jsonUnique.isNotEmpty
        ? jsonUnique.map((e) => properties.firstWhere((p) => p.name == e.toString())).toList()
        : <XProperty>[];

    defaultIdentifier = null != json["defaultIdentifier"]
      ? properties.firstWhere((p) => p.name == json['defaultIdentifier'])
      : null;

    // Ensure stable uid for loaded concepts: prefer name when available
    if (name.isNotEmpty) {
      uid = name;
    } else {
      uid = DateTime.now().microsecondsSinceEpoch.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final propsMap = <String, dynamic>{};
    for (final p in properties) {
      if (p.name.isNotEmpty) propsMap[p.name] = p.type.toJson();
    }

    var jsonData = <String, dynamic>{
      "type": type,
      "name": name,
      'namespacePrefix': namespacePrefix,
      'description': description,
      'properties': propsMap,
      'required': required.map((r) => r.name).toList(),
      'unique': unique.map((u) => u.name).toList(),
      'defaultIdentifier': defaultIdentifier?.name
    };
    jsonData.removeWhere((key, value) => value == null || value == "");
    return jsonData;
  }
}