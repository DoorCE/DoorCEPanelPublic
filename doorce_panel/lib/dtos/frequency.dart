class Frequency {
  final String code;
  final String description;
  final String label;

  Frequency({
    required this.code,
    required this.description,
    required this.label,
  });

  factory Frequency.fromJson(Map<String, dynamic> json) {
    return Frequency(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      label: json['label'] ?? '',
    );
  }
}