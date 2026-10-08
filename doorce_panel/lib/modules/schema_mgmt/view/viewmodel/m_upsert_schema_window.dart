import 'package:doorce_panel/common/consts/restricted_keywords.dart';
import 'package:doorce_panel/common/types/primitive_types.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/namespace.dart';
import 'package:doorce_panel/dtos/property.dart';
import 'package:doorce_panel/dtos/property_type.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class MUpsertSchemaWindow {
  final XDataSchema schema;
  final List<XSchemaSeries> _schemaSeriesResources;
  final List<XNamespace> _standardNamespaces;
  final List<XDataset>? datasets;

  late bool isInsert;
  late bool isPreview;

  MUpsertSchemaWindow(
      this.schema,
      this._schemaSeriesResources,
      this._standardNamespaces,
      this.datasets,
      isPreview){
        this.isPreview = isPreview ?? false;
      }

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = schema.identifier.isEmpty;
  }
  

  // **** Schema ****

  bool isSchemaEditable() {
    return !isPreview && (datasets == null || datasets!.isEmpty);
  }

  // Identifiers
  String createSchemaIdentifier(String title){
    return MUriGenerator.generateUriFromResource(schema, title);
  }

  // **** Namespaces ****

  //* Setters
  void addCustomNamespace(String iri, String prefix) {
    final newNamespace = XNamespace()
      ..prefix = prefix
      ..iri = iri
      ..isCustom = true;

    // Only add if not already present
    if (!schema.namespaces.any((ns) => ns.iri == iri)) {
      schema.namespaces.add(newNamespace);
    }
  }

  //* Validators
  bool isNamespaceNew(String prefix) {
    return !schema.namespaces.any((ns) =>
        ns.prefix == prefix);
  }

  bool isDefaultNamespaceNull() {
    return schema.defaultNamespacePrefix == null;
  }

  bool isCustomIriUnique(String? iri) {
    return !_standardNamespaces.any((ns) => ns.iri == iri);
  }

  bool isCustomPrefixUnique(String? prefix) {
    return !_standardNamespaces.any((ns) => ns.prefix == prefix);
  }

  bool isNamespaceUnique(String iri, String prefix) {
    return isCustomIriUnique(iri) && isCustomPrefixUnique(prefix);
  }

  //* Getters
  List<XNamespace> getCustomNamespaces() {
    return schema.namespaces.where((namespace) =>
        !_standardNamespaces.any((std) => std.iri == namespace.iri)).toList();
  }

  List<XNamespace> _getAllNamespaceOptions() {
    return [
      ..._standardNamespaces,
      ...schema.namespaces.where((namespace) =>
        !_standardNamespaces.any((std) => std.iri == namespace.iri))
    ];
  }
  
  //* Options for dropdowns
  List<DropdownItem<XNamespace>> getDefaultNamespaceOptions() {
    List<XNamespace> newNamespaces = schema.namespaces
        .where((ns) => ns.isCustom)
        .toList();
    return newNamespaces
                  .map((entry) => DropdownItem<XNamespace>(
                        value: entry,
                        label: entry.prefix,
                        selected: schema.defaultNamespacePrefix != null ? entry.prefix == schema.defaultNamespacePrefix : false,),
                      )
                  .toList();
  }

  List<DropdownItem<XNamespace>> getSchemaNamespaceOptions () {
    List<XNamespace> allNamespaceOptions = _getAllNamespaceOptions();
    return allNamespaceOptions.map((namespace) =>
      DropdownItem<XNamespace>(
        value: namespace,
        label: namespace.prefix.isNotEmpty ? "${namespace.prefix}: ${namespace.iri}" : namespace.iri,
        selected: schema.namespaces.any((n) => namespace.prefix == n.prefix)
      )
    ).toList();
  }

  List<DropdownItem<String>> getNamespaceDropdownItems(BuildContext context, String? selectedPrefix) {
    // The label for the "default" option should always reflect the current defaultNamespacePrefix
    List<DropdownItem<String>> items = [
      DropdownItem<String>(
        value: "",
        label: "${AppLocalizations.of(context)!.defaultValue}"
            "${schema.defaultNamespacePrefix != null && schema.defaultNamespacePrefix!.isNotEmpty ? " (${schema.defaultNamespacePrefix})" : ""}",
        selected: selectedPrefix == null || selectedPrefix.isEmpty
      ),
    ];
    items.addAll(schema.namespaces.map((entry) => DropdownItem<String>(
          value: entry.prefix,
          label: entry.prefix,
          selected: selectedPrefix == entry.prefix,
        )));
    return items;
  }

  // **** Concepts ****

  //* Setters
  void addEmptyConcept() {
    // Prevent adding another empty concept if one already exists
    if (!schema.concepts.any((c) => c.name.isEmpty)) {
      schema.concepts.add(XConcept());
    } 
  }
  
  void updateConceptDescription(String conceptUid, String value) {
    // schema.concepts[conceptIdx].description = value;
  }

  void updateConceptNamespace(int conceptIdx, String? namespacePrefix) {
    schema.concepts[conceptIdx].namespacePrefix = namespacePrefix;
  }

  //* Delete
  void removeConcept(XConcept concept) {
    // Remove from mainConceptName if needed
    if (schema.mainConcept?.uid == concept.uid) {
      schema.mainConcept = null;
    }
    schema.concepts.removeWhere((c) => c.uid == concept.uid);
  }

  //* Validators
  bool isConceptsEmpty() {
    return schema.concepts.isEmpty;
  }

  //* Options for dropdowns
  List<DropdownItem<XConcept>> getMainConceptOptions(BuildContext context) {
    return schema.concepts
      .map((concept) {
        return DropdownItem<XConcept>(
          value: concept,
          label: concept.name.isNotEmpty
            ? concept.name
            : "${AppLocalizations.of(context)!.untitledConcept}",
          selected: concept.uid == schema.mainConcept?.uid
        );
      }).toList();
  }

  List<DropdownItem<XProperty>> getConceptDefaultIdOptions(BuildContext context, XConcept concept) {
    return concept.properties.map((prop) {
      return DropdownItem<XProperty>(
        value: prop,
        label: prop.name.isNotEmpty
          ? prop.name
          : AppLocalizations.of(context)!.untitledProperty,
        selected: concept.defaultIdentifier?.name == prop.name
      );
    }).toList();
  }

  // **** Schema Series ****

  List<DropdownItem<XSchemaSeries>> getSchemaSeriesOptions(
      BuildContext context) {
    return _schemaSeriesResources.map((series) {
      return DropdownItem<XSchemaSeries>(
        value: series,
        label: series.title,
        selected: schema.seriesIdentifier == series.identifier
      );
    }).toList();
  }

  // **** Properties ****

  //* Setters
  void addEmptyProperty(XConcept concept) {
      // Prevent adding another empty property if one already exists
      if (!concept.properties.any((p) => p.name.isEmpty)) {
        var newProp = XProperty()
          ..name = ""
          ..type = XPropertyType();
        concept.properties.add(newProp);
      }
  }

  void updatePropertyName(XConcept concept, XProperty property, String newName) {
      if (concept.properties.any((p) => p.name == newName)) return; // name already exists

      property.name = newName;
  }

  void updatePropertyDescription(int conceptIdx, String propName, String value) {
      final concept = schema.concepts[conceptIdx];
      final property = concept.properties.firstWhere((p) => p.name == propName);

      property.type.description = value;
  }

  void updatePropertyType(XProperty property, String? typeValue) { // typeValue might be a type name or a concept name (then it's marked as "reference")
      // check if type refers to a concept name
      if (schema.concepts.any((c) => c.name == typeValue)) {
        property.type.type = "reference";
        // If the type is a reference, set the target to the concept name
        property.type.target = typeValue;
      } else {
        property.type.type = typeValue;
        property.type.target = null;
      }
  }

  void updatePropertyArray(int conceptIdx, String propName, bool isArray) {
      final concept = schema.concepts[conceptIdx];
      final property = concept.properties.firstWhere((p) => p.name == propName);

      property.type.isArray = isArray;
  }

  void updatePropertyRequired(XConcept concept, XProperty property, bool isRequired) {
        if (isRequired) {
          if (!concept.required.any((r) => r.uid == property.uid)) {
            concept.required.add(property);
          }
        } else {
          concept.required.removeWhere((r) => r.uid == property.uid);
        }
  }

  void updatePropertyUnique(XConcept concept, XProperty property, bool isUnique) {
        if (isUnique) {
          if (!concept.unique.any((u) => u.uid == property.uid)) {
            concept.unique.add(property);
          }
        } else {
          concept.unique.removeWhere((u) => u.uid == property.uid);
        }
  }

  void updatePropertyNamespace(int conceptIdx, String propName, String? namespacePrefix) {
      final property = schema.concepts[conceptIdx].properties.firstWhere((p) => p.name == propName);
      
      property.type.namespacePrefix = namespacePrefix;
  }

  //* Delete
  void removeProperty(XConcept concept, XProperty property) {
      concept.properties.removeWhere((p) => p.uid == property.uid);
      concept.required.removeWhere((p) => p.uid == property.uid);
      concept.unique.removeWhere((p) => p.uid == property.uid);
  }

  //* Validators
  bool doesPropertyNameMatchKeywords(String name) {
    return RestrictedKeywords.keywords.any((keyword) => name.toLowerCase().split(" ").contains(keyword.toLowerCase()));
  }

  //* Options for dropdowns
  List<DropdownItem<String>> getTypeDropdownItems(BuildContext context, XPropertyType? propertyType) {
    List<DropdownItem<String>> typeOptions = [];

    typeOptions.addAll(PrimitiveType.values.map((primitiveType) => DropdownItem<String>(
              value: primitiveType.name,
              label: primitiveType.name,
              selected: propertyType?.type == primitiveType.name,
            )).toList());

    typeOptions.addAll(schema.concepts.map((concept) {
      return DropdownItem<String>(
        value: concept.name,
        label: concept.name.isNotEmpty ? concept.name : AppLocalizations.of(context)!.untitledConcept,
        selected: propertyType?.target == concept.name,
      );
    }).toList());
    
    return typeOptions;
  }
}