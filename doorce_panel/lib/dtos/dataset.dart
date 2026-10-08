import 'package:doorce_panel/dtos/data_resource.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';

class XDataset extends XDataResource {
  List<int> type = List<int>.empty(growable: true);
  DatasetStatus status = DatasetStatus.draft;
  List<String> documentation = List<String>.empty(growable: true);
  List<String> provenance = List<String>.empty(growable: true);
  String version = "";
  String? versionNotes;
  List<String> seriesID = [];
  Map<String, Map<String,String>> seriesTitle = <String, Map<String,String>>{};
  String? schemaID;
  String? schemaTitle;
  String? targetDatasetID;

  XDataset();
  XDataset.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);

    status = DatasetStatus.values[json['status'] ?? 0];
      
    type = (json["type"] is List)
        ? List<int>.from(json["type"])
        : (json["type"] != null ? [json["type"]] : []);

    documentation = List<String>.from(json['documentation'] ?? []);
    provenance = List<String>.from(json['provenance'] ?? []);
    version = json['version'] ?? '';
    versionNotes = json['versionNotes'] ?? '';

    seriesID = List<String>.from(json['seriesUris'] ?? []);

    seriesTitle = <String, Map<String,String>>{};
    if (json['seriesTitles'] != null && json['seriesTitles'].isNotEmpty) {
      for (final id in seriesID) {
        if (json['seriesTitles'][id] != null) {
          seriesTitle[id] = Map<String, String>.from(json['seriesTitles'][id]);
        }
      }
    }

    schemaID = json['schemaUri'] ?? '';
    schemaTitle = json['schemaTitle'] ?? '';

    targetDatasetID = json['targetDatasetUri'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': type,
      'status': status.index,
      'documentation': documentation,
      'provenance': provenance,
      'version': version,
      'versionNotes': versionNotes,
      'seriesUris': seriesID,
      'schemaUri': schemaID,
      'schemaTitle': schemaTitle,
      'targetDatasetUri': targetDatasetID,
    };
  }

  @override
  String toString() {
    return '''
      XDataset {
        type: $type,
        status: $status,
        documentation: $documentation,
        provenance: $provenance,
        version: $version,
        versionNotes: $versionNotes,
        seriesUris: $seriesID,
        seriesTitles: $seriesTitle,
        schemaUri: $schemaID,
        schemaTitle: $schemaTitle,
        targetDatasetUri: $targetDatasetID,
        geographicalCoverage: $geographicalCoverage,
        frequency: $frequency,
        temporalCoverage: $temporalCoverage,
        releaseDate: $releaseDate,
        accessRights: $accessRights,
        languages: $languages,
        keywords: $keywords,
        themes: $themes,
        applicableLegislations: $applicableLegislation,
        licences: $licence,
        catalogueUri: $catalogueID,
        catalogueTitle: $catalogueTitle,
        iconUri: $iconUri,
        responsiblePersonUri: $responsiblePersonID,
        responsiblePersonName: $responsiblePersonName,
        responsibleOrganisationUri: $responsibleOrganisationID,
        responsibleOrganisationName: $responsibleOrganisationName,
        editorsUris: $editorIDList,
        contactsUris: $contactIDList,
        title: $title,
        description: $description,
        uri: $identifier
      }
    ''';
  }
}
