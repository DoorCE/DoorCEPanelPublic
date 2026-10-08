class MaturityStatus {
  String code = "";
  String description = "";
  String label = "";

  MaturityStatus();

  void fromJson(Map<String, dynamic> json) {
    code = json['code'] ?? "";
    description = json['description'] ?? "";
    label = json['label'] ?? "";
  }
}
