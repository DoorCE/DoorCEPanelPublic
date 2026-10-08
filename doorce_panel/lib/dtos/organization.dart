import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/dtos/agent.dart';

class XOrganization extends XAgent {
  String name = "";
  List<String> membersUris = List<String>.empty(growable: true);
  Map<String, List<ManagerRole>> membersRoles = <String, List<ManagerRole>>{};

  XOrganization();
  XOrganization.forInsert() {
    userRoles = [ManagerRole.AgentManager, ManagerRole.MetadataManager];
  }

  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = json['name'] ?? "";
    membersUris = List<String>.from(json['membersUris'] ?? []);
    membersRoles = (json['membersRoles'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, List<ManagerRole>.from(value.map((e) => ManagerRole.values.firstWhere((role) => role.index == e))))
    ) ?? {};
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'name': name,
      'membersUris': membersUris,
      'membersRoles': membersRoles.map((key, value) => MapEntry(key, value.map((e) => e.index).toList())),
    };
  }

  @override
  String toString() {
    return '''
      XOrganization {
        identifier: $identifier,
        name: $name,
        membersUris: $membersUris,
        contactsUris: $contactsUris,
        description: $description
      }
    ''';
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), name];
  }
}
