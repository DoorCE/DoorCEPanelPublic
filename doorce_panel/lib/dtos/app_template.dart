import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/manageable_resource.dart';

class XAppTemplate extends XManageableResource {
  String title = "";
  String description = "";

  String language = "";
  bool? isReady = false;
  String schemaUri = "";
  String? schemaTitle;
  Map<String,String> useCaseScenarios = <String,String>{};
  String? appDataSpecification;
  String? versionOfUri;
  String? versionOfName;
  List<XConcept> auxiliaryConcepts = List<XConcept>.empty(growable: true);
  
  XAppTemplate();
  XAppTemplate.forInsert() : super.forInsert();
  
  
  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    title = json['title'] ?? "";
    description = json['description'] ?? "";
    language = json['language'] ?? "";
    isReady = json['isReady'] ?? null;
    schemaUri = json['schemaUri'] ?? "";
    schemaTitle = json['schemaTitle'] ?? "";
    useCaseScenarios = Map<String,String>.from(json['useCaseScenarios'] ?? {});
    appDataSpecification = json['dataSpecification'] ?? null;
    versionOfUri = json['versionOfUri'] ?? null;
    versionOfName = json['versionOfName'] ?? null;
    auxiliaryConcepts = (json['auxiliaryConcepts'] as List<dynamic>?)
        ?.map((c) => XConcept()..fromJson(c as Map<String, dynamic>))
        .toList() ?? [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'title': title,
      'description': description,
      'language': language,
      'isReady': isReady,
      'schemaUri': schemaUri,
      'schemaTitle': schemaTitle,
      'useCaseScenarios': useCaseScenarios,
      'appDataSpecification': appDataSpecification,
      'versionOfUri': versionOfUri,
      'versionOfName': versionOfName,
      "auxiliaryConcepts": auxiliaryConcepts.map((c) => c.toJson()).toList(),
    };
  }

  @override
  List<String> getSearchableFields() {
    return [...super.getSearchableFields(), title];
  }
}