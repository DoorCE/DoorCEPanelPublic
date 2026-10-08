import 'package:doorce_panel/dtos/data_resource.dart';

class XDatasetSeries extends XDataResource {
  XDatasetSeries();
  XDatasetSeries.forInsert() : super.forInsert();

  @override
  String toString() {
    return '''
      XDatasetSeries {
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
        licence: $licence,
        catalogueID: $catalogueID,
        catalogueTitle: $catalogueTitle,
        geographicalCoverage: $geographicalCoverage,
        'frequency: $frequency, '
        'temporalCoverage: $temporalCoverage, '
        releaseDate: $releaseDate
      }
    ''';
  }
}
