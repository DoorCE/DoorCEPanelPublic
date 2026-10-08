import 'dart:typed_data';

import 'package:doorce_panel/dtos/multi_description_element.dart';

class XDistribution extends XMultiDescriptionElement{
  String? status;
  String datasetUri = "";
  Map<String, String> datasetTitle = <String, String>{};
  String? dataServiceUri;
  Map<String, String> dataServiceTitle = <String, String>{};
  List<String> accessUrl = List<String>.empty(growable: true);
  String? format;
  int accessStatus = 0;
  int byteSize = 0;
  List<String> languages = List<String>.empty(growable: true);
  String? mediaType;
  DateTime? releaseDate;
  String? schemaTitle;
  String? schemaUri;
  String datasetIconUri = "";
  Uint8List? icon;
  int? fileId;
  String? fileName;
  bool isUserEditable = true;
  Map<String, String> checksum = <String, String>{};
	String? compressionFormat;
  String? downloadUrl;

  XDistribution();


  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    status = json['status'];
    datasetUri = json['datasetUri'] ?? "";
    datasetTitle = Map<String, String>.from(json['datasetTitle'] ?? {});
    dataServiceUri = json['dataServiceUri'];
    dataServiceTitle = Map<String, String>.from(json['dataServiceTitle'] ?? {});
    accessUrl = List<String>.from(json['accessUrl'] ?? []);
    format = json['format'];
    accessStatus = json['accessStatus'] ?? 0;
    byteSize = json['byteSize'] ?? 0;
    languages = List<String>.from(json['languages'] ?? []);
    mediaType = json['mediaType'];
    releaseDate = json['releaseDate'] != null
        ? DateTime.parse(json['releaseDate'])
        : null;
    schemaTitle = json['schemaTitle'] ?? "";
    schemaUri = json['schemaUri'] ?? "";
    datasetIconUri = json['datasetIconUri'] ?? "";
    fileId = json['fileId'] ?? 0;
    fileName = json['fileName'] ?? null;
    isUserEditable = json['isUserEditable'] ?? false;
    checksum = Map<String, String>.from(json['checksum'] ?? {});
    compressionFormat = json['compressionFormat'] ?? null;
    downloadUrl = json['downloadUrl'] ?? null;
  }

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'status': status,
      'datasetUri': datasetUri,
      'dataServiceUri': dataServiceUri,
      'accessUrl': accessUrl,
      'format': format,
      'accessStatus': accessStatus,
      'byteSize': byteSize,
      'languages': languages,
      'mediaType': mediaType,
      'releaseDate': releaseDate?.toIso8601String(),
      'schemaUri': schemaUri,
      'datasetIconUri': datasetIconUri,
      'fileId': fileId,
      'fileName': fileName,
      'isUserEditable': isUserEditable,
      'downloadUrl': downloadUrl,
      'checksum': checksum,
      'compressionFormat': compressionFormat,
    };
  }

  @override
  String toString() {
    return '''
      XDistribution {
        status: $status,
        datasetUri: $datasetUri,
        datasetTitle: $datasetTitle,
        dataServiceUri: $dataServiceUri,
        dataServiceTitle: $dataServiceTitle,
        accessUrl: $accessUrl,
        format: $format,
        accessStatus: $accessStatus,
        byteSize: $byteSize,
        languages: $languages,
        mediaType: $mediaType,
        releaseDate: $releaseDate,
        title: $title,
        description: $description,
        identifier: $identifier,
        schemaTitle: $schemaTitle,
        schemaUri: $schemaUri,
        datasetIconUri: $datasetIconUri,
        fileId: $fileId,
        fileName: $fileName,
      }
    ''';
  }
}
