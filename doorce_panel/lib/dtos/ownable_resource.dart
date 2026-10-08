import 'dart:typed_data';

import 'package:doorce_panel/dtos/manageable_resource.dart';

abstract class XOwnableResource extends XManageableResource {
  Map<String,String> title = <String,String>{};
	Map<String,String> description = <String,String>{};

  String? iconUri;
  Uint8List? icon;
  String? responsiblePersonID;
  String? responsiblePersonName;
  String? responsibleOrganisationID;
  String? responsibleOrganisationName;
  List<String> contactIDList = List<String>.empty(growable: true);

  XOwnableResource();
  XOwnableResource.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = Map<String, String>.from(json['title'] ?? {});
    description = Map<String, String>.from(json['description'] ?? {});
    iconUri = json['iconUri'];
    responsiblePersonID = json['responsiblePersonUri'] ?? '';
    responsiblePersonName = json['responsiblePersonName'] ?? '';
    responsibleOrganisationID = json['responsibleOrganisationUri'] ?? '';
    responsibleOrganisationName =
        json['responsibleOrganisationName'] ?? '';
    contactIDList = List<String>.from(json['contactsUris'] ?? []);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'title': title,
      'description': description,
      'iconUri': iconUri,
      'responsiblePersonUri': responsiblePersonID,
      'responsiblePersonName': responsiblePersonName,
      'responsibleOrganisationUri': responsibleOrganisationID,
      'responsibleOrganisationName': responsibleOrganisationName,
      'contactsUris': contactIDList,
    };
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), ...title.values];
  }

}