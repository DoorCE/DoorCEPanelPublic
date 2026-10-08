class XNamespace 
{
  String prefix = "";
  String iri = "";
  bool isCustom = true;

  XNamespace();

  Map<String, dynamic> toJson() {
    return {
      'prefix': prefix,
      'iri': iri,
      'isCustom': isCustom,
    };
  }
  void fromJson(Map<String, dynamic> json) {
    prefix = json['prefix'] ?? '';
    iri = json['iri'] ?? '';
    isCustom = json['isCustom'] ?? false;
  }
  @override
  String toString() {
    return 'XNamespace { prefix: $prefix, iri: $iri, isCustom: $isCustom }';
  }
}