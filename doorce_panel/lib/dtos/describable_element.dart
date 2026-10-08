import 'package:doorce_panel/dtos/identifiable_element.dart';

class XDescribableElement extends XIdentifiableElement
{
  String title = "";
  String description = "";

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = json['title'] ?? '';
    description = json['description'] ?? '';
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), title];
  }
}