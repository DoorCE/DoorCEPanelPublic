import 'package:doorce_panel/common/types/app_status.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/dtos/manageable_resource.dart';

class XApp extends XManageableResource {
  String description = "";
  String title = "";

  String activeResourceUri = "";
  Map<String, String> activeResourceTitle = <String, String>{};
  String templateUri = "";
  String? templateTitle;
  List<String> sourceResourceUris = List<String>.empty(growable: true);
  Map<String, Map<String, String>> sourceResourceTitles = <String, Map<String,String>>{};

  bool? isEnabled;
  bool? isVisible;

  AppStatus status = AppStatus.Created;

  bool? isDefault;

  XApp();
  XApp.clone(XApp xApp) {
    identifier = xApp.identifier;
    description = xApp.description;
    title = xApp.title;
    activeResourceUri = xApp.activeResourceUri;
    activeResourceTitle = Map<String, String>.from(xApp.activeResourceTitle);
    templateUri = xApp.templateUri;
    templateTitle = xApp.templateTitle;
    sourceResourceUris = List<String>.from(xApp.sourceResourceUris);
    sourceResourceTitles = xApp.sourceResourceTitles.map((key, value) => MapEntry(key, Map<String, String>.from(value)));
    isEnabled = xApp.isEnabled;
    isVisible = xApp.isVisible;
    isDefault = xApp.isDefault;
    editorIDList = List<String>.from(xApp.editorIDList);
    editorRoles = xApp.editorRoles.map((key, value) => MapEntry(key, List<EditorRole>.from(value)));
    userRoles = List<EditorRole>.from(xApp.userRoles);
  }
  XApp.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    description = json['description'] ?? "";
    title = json['title'] ?? "";
    activeResourceUri = json['activeResourceUri'] ?? "";
    activeResourceTitle =  Map<String, String>.from(json['activeResourceTitle'] ?? {});
    templateUri = json['templateUri'] ?? "";
    templateTitle = json['templateTitle'] ?? "";

    sourceResourceUris = List<String>.from(json['sourceResourceUris'] ?? []);

    sourceResourceTitles = <String, Map<String,String>>{};
    if (json['sourceResourceTitles'] != null && json['sourceResourceTitles'].isNotEmpty) {
      for (final id in sourceResourceUris) {
        if (json['sourceResourceTitles'][id] != null) {
          sourceResourceTitles[id] = Map<String, String>.from(json['sourceResourceTitles'][id]);
        }
      }
    }

    isEnabled = json['isEnabled'] ?? false;
    isVisible = json['isVisible'] ?? false;

    status = AppStatus.values[json['status'] ?? 0];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'description': description,
      'title': title,
      'activeResourceUri': activeResourceUri,
      'activeResourceTitle': activeResourceTitle,
      'templateUri': templateUri,
      'templateTitle': templateTitle,
      'sourceResourceUris': sourceResourceUris,
      'sourceResourceTitles': sourceResourceTitles,
      'isEnabled': isEnabled ?? false,
      'isVisible': isVisible ?? false,
      'status': status.index,
    };
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), title];
  }
}