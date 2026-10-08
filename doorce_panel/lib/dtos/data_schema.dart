import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/describable_element.dart';
import 'package:doorce_panel/dtos/namespace.dart';

class XDataSchema extends XDescribableElement
{
  List<XConcept> concepts = List<XConcept>.empty(growable: true);
  String seriesIdentifier = "";
  String? seriesTitle;
  List<XNamespace> namespaces = List<XNamespace>.empty(growable: true);
  String? defaultNamespaceIri;
  String? defaultNamespacePrefix;

  bool isUserEditable = true;

  XConcept? mainConcept;
  

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    concepts = (json['concepts'] as List<dynamic>?)
        ?.map((c) => XConcept()..fromJson(c as Map<String, dynamic>))
        .toList() ?? List<XConcept>.empty(growable: true);
    namespaces = (json['usedNamespaces'] as List<dynamic>?)
        ?.map((n) => XNamespace()..fromJson(n as Map<String, dynamic>))
        .toList() ?? List<XNamespace>.empty(growable: true);
    defaultNamespaceIri = json['defaultNamespaceIri'] ?? '';
    defaultNamespacePrefix = json['defaultNamespacePrefix'] ?? '';
    mainConcept = null != json["mainConceptName"]
      ? concepts.firstWhere((c) => c.name == json['mainConceptName'])
      : null;
    // Series information
    seriesIdentifier = json['seriesUri'] ?? '';
    seriesTitle = json['seriesTitle'] ?? '';
    isUserEditable = json['isUserEditable'] ?? false;
  }

  Map<String, dynamic> toJson() {
    var jsonData = {
      'uri': identifier,
      'title': title,
      'description': description,
      "concepts": concepts.map((c) => c.toJson()).toList(),
      'seriesUri': seriesIdentifier,
      'seriesTitle': seriesTitle,
      "defaultNamespaceIri": defaultNamespaceIri,
      "defaultNamespacePrefix": defaultNamespacePrefix,
      "usedNamespaces": namespaces.map((n) => n.toJson()).toList(),
      "mainConceptName": mainConcept?.name,
      "isUserEditable": isUserEditable,
    };

    // Remove entries with null values
    jsonData.removeWhere((key, value) => value == null || value == "");
    return jsonData;
  }

  @override
  String toString() {
    return '''
      XDataSchema {
        uri: $identifier,
        title: $title,
        description: $description,
        concepts: ${concepts.toString()},
        seriesUri: $seriesIdentifier,
        seriesTitle: $seriesTitle,
        usedNamespaces: ${namespaces.map((n) => n.toString()).join(', ')},
        defaultNamespaceIri: $defaultNamespaceIri,
        defaultNamespacePrefix: $defaultNamespacePrefix
      }
    ''';
  }
  }