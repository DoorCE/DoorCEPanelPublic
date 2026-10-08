import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';

class XAgent extends XIdentifiableElement {
  String? description;
  List<String> contactsUris = List<String>.empty(growable: true);
  List<ManagerRole> userRoles = List<ManagerRole>.empty(growable: true);
  bool isOrganization = false;

  XAgent();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = json['description'] ?? "";
    contactsUris = List<String>.from(json['contactsUris'] ?? []);
    userRoles = (json['userRoles'] as List<dynamic>?)
            ?.map((e) => ManagerRole.values.firstWhere((role) => role.index == e))
            .toList() ??
        [];
    isOrganization = json['isOrganization'] ?? false;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      'contactsUris': contactsUris,
      'userRoles': userRoles.map((role) => role.index).toList(),
      'isOrganization': isOrganization
    };
  }
}