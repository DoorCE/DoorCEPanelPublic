import 'package:doorce_panel/dtos/identifiable_element.dart';

abstract class XMultiDescriptionElement extends XIdentifiableElement {

	Map<String,String> title = <String,String>{};
	Map<String,String> description = <String,String>{};

	XMultiDescriptionElement();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = Map<String, String>.from(json['title'] ?? {});
    description = Map<String, String>.from(json['description'] ?? {});
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'title': title,
      'description': description,
    };
  }
}