class XIconData {
  String? iconUri;
  String? iconName;

  XIconData();
  
  void fromJson(Map<String, dynamic> json) {
    iconUri = json['iconUri'];
    iconName = json['iconName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'iconUri': iconUri,
      'iconName': iconName
    };
  }

  @override
  String toString() {
    return '''
      XIconData {
        iconUri: $iconUri,
        iconName: $iconName
      }
    ''';
  }
}
