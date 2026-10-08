import 'package:doorce_panel/dtos/catalogued_resource.dart';

class XDatasetService extends XCataloguedResource {
  List<String> endpointURL = List<String>.empty(growable: true);
  List<String> endpointDescription = List<String>.empty(growable: true);
  List<String> documentation = List<String>.empty(growable: true);
  List<String> format = List<String>.empty(growable: true);
  int status = 0;

  XDatasetService();
  XDatasetService.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    endpointURL = List<String>.from(json['endpointUrl'] ?? []);
    endpointDescription = List<String>.from(json['endpointDescription'] ?? []);
    documentation = List<String>.from(json['documentation'] ?? []);
    format = List<String>.from(json['format'] ?? []);
    status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'endpointUrl': endpointURL,
      'endpointDescription': endpointDescription,
      'documentation': documentation,
      'format': format,
      'status': status,
    };
  }

  @override
  String toString() {
    return '''
      XDatasetService {
        identifier: $identifier,
        title: $title,
        description: $description,
        iconUri: $iconUri,
        responsiblePersonID: $responsiblePersonID,
        responsiblePersonName: $responsiblePersonName,
        responsibleOrganisationID: $responsibleOrganisationID,
        responsibleOrganisationName: $responsibleOrganisationName,
        editorIDList: $editorIDList,
        contactIDList: $contactIDList,
        accessRights: $accessRights,
        languages: $languages,
        keywords: $keywords,
        themes: $themes,
        applicableLegislation: $applicableLegislation,
        licences: $licence,
        catalogueID: $catalogueID,
        catalogueTitle: $catalogueTitle,
        endpointUrl: $endpointURL,
        endpointDescription: $endpointDescription,
        documentation: $documentation,
        format: $format,
        status: $status
      }
    ''';
  }
}
