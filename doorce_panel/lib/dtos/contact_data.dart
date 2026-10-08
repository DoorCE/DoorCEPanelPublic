import 'package:doorce_panel/dtos/identifiable_element.dart';

class XContactData extends XIdentifiableElement {
  String name = "";
  String contents = "";
  String? agentName;
  String? agentID;

  XContactData();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contents': contents,
      'agentUri': agentID,
      'agentName': agentName,
      'uri': identifier,
    };
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    contents = json['contents'] ?? "";
    agentID = json['agentUri'];
    agentName = json['agentName'];
    identifier = json['uri'] ?? "";
  }

  @override
  String toString() {
    return '''
      XContactData {
        name: $name,
        contents: $contents,
        agentID: $agentID,
        agentName: $agentName,
        identifier: $identifier
      }
    ''';
  }
}
