import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/dtos/agent.dart';

class XPerson extends XAgent {
  List<String> givenNames = List<String>.empty(growable: true);
  String familyName = "";
  List<String> organisationsUris = List<String>.empty(growable: true);
  Map<String, String> organisationsNames = {};
  Map<String, List<ManagerRole>> rolesInOrganisations = <String, List<ManagerRole>>{};
  String? userId;
  String? userEmail;
  String? userPassword;

  String get fullName => "${givenNames.first} ${familyName}";

  XPerson();
  XPerson.forInsert(){
    userRoles = [ManagerRole.AgentManager];
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    givenNames = List<String>.from(json['givenNames'] ?? []);
    familyName = json['familyName'] ?? "";
    organisationsUris = List<String>.from(json['organisationsUris'] ?? []);
    organisationsNames =
        Map<String, String>.from(json['organisationsNames'] ?? {});
    rolesInOrganisations = (json['rolesInOrganisations'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(
        key,
        List<ManagerRole>.from(value.map((e) => ManagerRole.values.firstWhere((role) => role.index == e))),
      ),
    ) ?? {};
    userId = json['userId'] ?? "";
    userEmail = json['userEmail'] ?? null;
    userPassword = json['userPassword'] ?? null;
  }

  @override
  Map<String, dynamic> toJson() {
    var jsonData = {
      ...super.toJson(),
      'givenNames': givenNames,
      'familyName': familyName,
      'organisationsUris': organisationsUris,
      'organisationsNames': organisationsNames,
      'rolesInOrganisations': rolesInOrganisations.map((key, value) => MapEntry(
        key,
        value.map((e) => e.index).toList(),
      )),
      'userId': userId,
      'userEmail': userEmail,
      'userPassword': userPassword
    };

    // Remove entries with null values
    jsonData.removeWhere((key, value) => value == null || value == "");
    return jsonData;
  }

  @override
  String toString() {
    return '''
      XPerson {
        identifier: $identifier,
        givenNames: $givenNames,
        familyName: $familyName,
        organisationsUris: $organisationsUris,
        organisationsNames: $organisationsNames,
        contactsUris: $contactsUris,
        description: $description
      }
    ''';
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), ...givenNames, familyName, userId ?? ""];
  }
}
