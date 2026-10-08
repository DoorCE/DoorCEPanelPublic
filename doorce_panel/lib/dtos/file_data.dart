import 'dart:typed_data';

class XFileData {
  int? fileId;
  String? fileName;
  String? contentType;
  Uint8List? content;

  String? downloadUrl;
  int? byteSize;

  XFileData({int? fileId, String? fileName, String? contentType, Uint8List? content, String? downloadUrl, int? byteSize}) {
    this.fileId = fileId;
    this.fileName = fileName;
    this.contentType = contentType;
    this.content = content;
    this.downloadUrl = downloadUrl;
    this.byteSize = byteSize;
  }
  
  void fromJson(Map<String, dynamic> json) {
    fileId = json['fileId'] ?? 0;
    fileName = json['fileName'] ?? "";
    contentType = json['contentType'] ?? "";
    content = json['content'];
    downloadUrl = json['downloadUrl'] ?? null;
    byteSize = json['byteSize'] ?? null;
  }

  Map<String, dynamic> toJson() {
    var jsonData = <String, dynamic>{
      'fileId': fileId,
      'fileName': fileName,
      'contentType': contentType,
      'content': content,
      'downloadUrl': downloadUrl,
      'byteSize': byteSize
    };

    jsonData.removeWhere((key, value) => value == null || value == "");
    return jsonData;
  }

  @override
  String toString() {
    return '''
      XIconData {
        fileId: $fileId,
        fileName: $fileName,
        contentType: $contentType,
        content: $content,
      }
    ''';
  }
}
