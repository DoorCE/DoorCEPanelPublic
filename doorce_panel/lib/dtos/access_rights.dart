class XAccessRights {
  String code = "";
  String description = "";
  String label = "";

  XAccessRights();

  void fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? "";
    description = json['description'] ?? "";
    label = json['label'] ?? "";
  }
}
