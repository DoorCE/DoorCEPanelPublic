import 'package:doorce_panel/dtos/ownable_resource.dart';

class XCatalogue extends XOwnableResource {
  String? parentID;
  Map<String, String> parentTitle = <String, String>{};

  XCatalogue();
  XCatalogue.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    parentID = json['partOfUri'];
    parentTitle = Map<String, String>.from(json['partOfTitle'] ?? {});
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'partOfUri': parentID,
      'partOfTitle': parentTitle,
    };
  }

  @override
  String toString() {
    return '''
      XCatalogue {
        identifier: $identifier,
        title: $title,
        responsiblePersonID: $responsiblePersonID,
        responsiblePersonName: $responsiblePersonName,
        responsibleOrganisationID: $responsibleOrganisationID,
        responsibleOrganisationName: $responsibleOrganisationName,
        "userRoles": ${userRoles}
      }
    ''';
  }
}
