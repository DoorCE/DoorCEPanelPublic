import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';

abstract class XManageableResource extends XIdentifiableElement {

	List<String> editorIDList = List<String>.empty(growable: true);
  Map<String, List<EditorRole>> editorRoles = <String, List<EditorRole>>{};
  List<EditorRole> userRoles = List<EditorRole>.empty(growable: true);

  XManageableResource();
  XManageableResource.forInsert(){
    userRoles = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
  }

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    editorIDList = List<String>.from(json['editorsUris'] ?? []);
    editorRoles = (json['editorsRoles'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, (value as List<dynamic>)
          .map((e) => EditorRole.values.firstWhere((role) => role.index == e))
          .toList()),
    ) ?? {};
    userRoles = (json['userRoles'] as List<dynamic>?)
            ?.map((e) => EditorRole.values.firstWhere((role) => role.index == e))
            .toList() ??
        [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'editorsUris': editorIDList,
      'editorsRoles': editorRoles.map((key, value) => MapEntry(key, value.map((e) => e.index).toList())),
      'userRoles': userRoles.map((role) => role.index).toList(),
    };
  }
}