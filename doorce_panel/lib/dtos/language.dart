class Language {
  String code = "";
  String codeLong = "";
  String name = "";

  Language({
    required this.code,
    required this.codeLong,
    required this.name,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] ?? '',
      codeLong: json['codeLong'] ?? '',
      name: json['name'] ?? '',
    );
  }
}