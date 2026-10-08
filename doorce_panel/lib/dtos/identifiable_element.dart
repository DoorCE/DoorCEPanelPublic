abstract class XIdentifiableElement {

	String identifier = "";

	XIdentifiableElement();

  void fromJson(Map<String, dynamic> json) {
    identifier = json['uri'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {'uri': identifier};
  }

  List<String> getSearchableFields() {
    return [identifier];
  }
}