class Licence {
  final String code;
  final String acronym;
  final String url;
  final String description;
  final String label;

  Licence({
    required this.code,
    required this.acronym,
    required this.url,
    required this.description,
    required this.label,
  });

  // Metodo per creare un'istanza di Licence da un JSON
  factory Licence.fromJson(Map<String, dynamic> json) {
    return Licence(
      code: json['code'] ?? '',
      acronym: json['acronym'] ?? '',
      url: json['url'] ?? '',
      description: json['description'] ?? '',
      label: json['label'] ?? '',
    );
  }
}
