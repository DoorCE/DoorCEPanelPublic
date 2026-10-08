class XType
{
  String? type;
  String? description;
  String? namespacePrefix;

  void fromJson(Map<String, dynamic> json) {
    type = json['items']?['type'] ?? json['type'] ?? '';
    description = json['description'] ?? json['items']?['description'] ??  '';
    namespacePrefix = json['namespacePrefix'] ?? json['items']?['namespacePrefix'] ?? '';
  }
}