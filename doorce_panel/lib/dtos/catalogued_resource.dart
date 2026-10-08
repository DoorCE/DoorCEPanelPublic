import 'package:doorce_panel/dtos/ownable_resource.dart';

abstract class XCataloguedResource extends XOwnableResource{

	int accessRights = 0;
	List<String> languages = List<String>.empty(growable: true);
	List<String> keywords = List<String>.empty(growable: true);
	List<String> themes = List<String>.empty(growable: true);
	List<String> applicableLegislation = List<String>.empty(growable: true);
	List<String> licence = List<String>.empty(growable: true);
	String catalogueID = "";
	Map<String,String> catalogueTitle = <String,String>{};

	XCataloguedResource();
  XCataloguedResource.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    accessRights = json['accessRights'] ?? 0;
    languages = List<String>.from(json['languages'] ?? []);
    keywords = List<String>.from(json['keywords'] ?? []);
    themes = List<String>.from(json['themes'] ?? []);
    applicableLegislation = List<String>.from(json['applicableLegislations'] ?? []);
    licence = List<String>.from(json['licences'] ?? []);
    catalogueID = json['catalogueUri'] ?? '';
    catalogueTitle = Map<String, String>.from(json['catalogueTitle'] ?? {});
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'accessRights': accessRights,
      'languages': languages,
      'keywords': keywords,
      'themes': themes,
      'applicableLegislations': applicableLegislation,
      'licences': licence,
      'catalogueUri': catalogueID,
      'catalogueTitle': catalogueTitle,
    };
  }

}