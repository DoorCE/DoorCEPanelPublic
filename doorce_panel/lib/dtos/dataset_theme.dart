class DatasetTheme {
  final String code;
  final String description;
  final String label;

  DatasetTheme({
    required this.code,
    required this.description,
    required this.label,
  });

  factory DatasetTheme.fromJson(Map<String, dynamic> json) {
    return DatasetTheme(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      label: json['label'] ?? '',
    );
  }
}
