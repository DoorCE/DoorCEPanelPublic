class XDataUploadRequest {
  String datasetUri = "";
  Map<String, String> tableNameToConceptUriMap = {};
  Map<String, String> tableNameToIdFieldNameMap = {};
  String? fileUrl;
  String? extension;

  void fromJson(Map<String, dynamic> json) {
    datasetUri = json['datasetUri'] ?? '';
    fileUrl = json['fileUrl'];
    extension = json['extension'];
    tableNameToConceptUriMap = Map<String, String>.from(
        json['tableNameToConceptUriMap'] ?? {});
    tableNameToIdFieldNameMap = Map<String, String>.from(
        json['tableNameToIdFieldNameMap'] ?? {});
  }

  Map<String, dynamic> toJson() {
    var jsonData = {
      'DatasetUri': datasetUri,
      'FileUrl': fileUrl,
      'Extension': extension,
      'TableNameToConceptUriMap': tableNameToConceptUriMap,
      'TableNameToIdFieldNameMap': tableNameToIdFieldNameMap,
    };

    // Remove entries with null values
    jsonData.removeWhere((key, value) => value == null || value == "");
    return jsonData;
  }

  String toString() {
    return toJson().toString();
  }
}