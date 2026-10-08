import 'package:doorce_panel/dtos/xtype.dart';

class XPropertyType extends XType
{
  bool isArray = false;
  XPropertyType? items;
  String? target;


  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    isArray = json['type'] == 'array';
    target = json['items']?['target'] ?? json['target'] ?? '';
  }

  Map<String, dynamic> toJson() {
    Map<String,dynamic> itemToJson = {
      'type': type,
      'target': target,
    };

    itemToJson.removeWhere((key, value) => value == null || value == "");

    Map<String,dynamic> propToJson = {
      'description': description,
      'namespacePrefix': namespacePrefix,
    };

    propToJson.removeWhere((key, value) => value == null || value == "");

    if (isArray) {
      Map<String,dynamic> dictWithArray = {
        "type" : "array",
        "items": itemToJson
      };
      dictWithArray.addAll(propToJson);
      return dictWithArray;
    } else {
      itemToJson.addAll(propToJson);
      return itemToJson;
    }
  }
  
  @override
  String toString() {
    return super.toString();
  }
}