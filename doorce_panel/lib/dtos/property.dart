import 'package:doorce_panel/dtos/property_type.dart';

class XProperty {
  String uid = "";
  String name = "";
  XPropertyType type = XPropertyType();

  XProperty() {
    uid = DateTime.now().microsecondsSinceEpoch.toString();
  }

  void fromJson(String conceptName, String key, Map<String, dynamic> json) {
    name = key;
    type = XPropertyType()..fromJson(json);

    if (name.isNotEmpty) {
      uid = conceptName + name;
    } else {
      uid = DateTime.now().microsecondsSinceEpoch.toString();
    }
  }
}