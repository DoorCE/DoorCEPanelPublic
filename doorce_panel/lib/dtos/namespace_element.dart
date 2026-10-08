class XNamespaceElement
{
  String name = "";
  String? identifier;
  String? namespacePrefix;

  void fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    identifier = json['uri'] ?? '';
    namespacePrefix = json['namespacePrefix'] ?? null;
  }
}