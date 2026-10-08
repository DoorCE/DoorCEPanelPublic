import 'package:doorce_panel/common/types/global_role.dart';

class XUserAccount
{
  String userId = "";
  List<GlobalRole> roles = [];
  String? personUri;
  String? personFullName;

  void fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? "";
    roles = (json['roles'] as List<dynamic>?)
            ?.map((e) => GlobalRole.values.firstWhere((role) => role.index == e))
            .toList() ??
        [];
    personUri = json['personUri'];
    personFullName = json['personFullName'];
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "roles": roles.map((role) => role.index).toList(),
      "personUri": personUri,
      "personFullName": personFullName
    };
  }

  List<String> getSearchableFields() {
    return [userId, personFullName ?? "", personUri ?? ""];
  }
}