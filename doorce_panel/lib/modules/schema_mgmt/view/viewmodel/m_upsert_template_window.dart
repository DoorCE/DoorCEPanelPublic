import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/property.dart';
import 'package:doorce_panel/dtos/property_type.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertTemplateWindow {
  final XAppTemplate template;
  final List<XAppTemplate> templates;
  late List<XDataSchema> schemas;
  final List<XAgent> agents;
  final List<Language> languages;
  late XUserAccount _currentUserAccount;
  late XAgent? currentAgent;

  late bool isInsert;
  late String? conceptNameForDefaultScenarios = null;
  late bool isAdvancedMode = false;
  late bool isPreview;

  static final List<String> propertyTypes = [
    'boolean',
    'integer',
    'number',
    'string',
  ];

  MUpsertTemplateWindow(
      this.template,
      this.templates,
      this.schemas,
      this.agents,
      this.languages,
      this._currentUserAccount,
      this.currentAgent,
      isPreview
      ){
        this.isPreview = isPreview ?? false;
      }

// ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = template.identifier.isEmpty;
    if (!isInsert) {
      isAdvancedMode = true;
    }
  }

  bool isMetadataEditable() {
    return !isPreview && isUserMetadataEditor();
  }

  bool isEditorsEditable() {
    return !isPreview && isUserOwnershipEditor();
  }

// ------------------------ USER ROLES ----------------------------------------

  bool isUserDataAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.DataAdmin);
  }

  bool isUserMetadataEditor() {
    return template.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isUserOwnershipEditor() {
    return template.userRoles.contains(EditorRole.OwnershipEditor);
  }

  void refreshUserRoles() {
    if (template.editorIDList.contains(currentAgent?.identifier)) {
      template.userRoles = (null != template.editorRoles[currentAgent!.identifier])
        ? List.from(template.editorRoles[currentAgent!.identifier]!) 
        : [];
    }
  }

// ------------------------ TEMPLATE -----------------------------------------------

  String createAppIdentifier(String title) {
    return MUriGenerator.generateUriFromResource(template, title);
  }

  bool validateScenarios() {
    for (var scenario in template.useCaseScenarios.entries) {
      if (scenario.key.isEmpty || scenario.value.isEmpty) {
        return false;
      }
    }
    return true;
  }

// -------------------------- TABS -----------------------------------------------

  bool isUsecaseScenariosEnabled() {
    return isAdvancedMode && isMetadataEditable();
  }

// -------------------------- CONCEPTS -----------------------------------------------

  //* Setters
  void addEmptyConcept() {
    // Prevent adding another empty concept if one already exists
    if (!template.auxiliaryConcepts.any((c) => c.name.isEmpty)) {
      template.auxiliaryConcepts.add(XConcept());
    } 
  }

  //* Delete
  void removeConcept(XConcept concept) {
    template.auxiliaryConcepts.removeWhere((c) => c.uid == concept.uid);
  }

  //* Validation
  bool isConceptDropdownEnabled() {
    return isMetadataEditable() && !isAdvancedMode;
  }

  bool areConceptsEnabled() {
    return isMetadataEditable() && isAdvancedMode;
   }

// ------------------------ PROPERTIES -----------------------------------------------

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

  void updatePropertyType(XProperty property, String? typeValue) { // typeValue might be a type name or a concept name (then it's marked as "reference")
      // check if type refers to a concept name
      if (template.auxiliaryConcepts.any((c) => c.name == typeValue)) {
        property.type.type = "reference";
        // If the type is a reference, set the target to the concept name
        property.type.target = typeValue;
      } else {
        property.type.type = typeValue;
        property.type.target = null;
      }
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

  //* Delete
  void removeProperty(XConcept concept, XProperty property) {
      concept.properties.removeWhere((p) => p.uid == property.uid);
      concept.required.removeWhere((p) => p.uid == property.uid);
      concept.unique.removeWhere((p) => p.uid == property.uid);
  }

  //* Options for dropdowns
  List<DropdownItem<String>> getTypeDropdownItems(BuildContext context, XPropertyType? propertyType) {
    List<DropdownItem<String>> typeOptions = [];

    typeOptions.addAll(schemas.firstWhere((s) => s.identifier == template.schemaUri).concepts.map((concept) {
      return DropdownItem<String>(
        value: concept.name,
        label: concept.name.isNotEmpty ? concept.name : AppLocalizations.of(context)!.untitledConcept,
        selected: propertyType?.target == concept.name,
      );
    }).toList());
    
    return typeOptions;
  }

// ------------------------ TEMPLATE EDITORS ---------------------------------------

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = template.editorRoles;

    if (template.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in template.editorIDList)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    template.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    template.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      template.editorIDList.add(currentAgent!.identifier);
      template.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

//------------------------- OPTIONS FOR DROPDOWNS -----------------------------

  List<DropdownItem<String>> getTemplateItems() {
    return templates.map((tml) {
      return DropdownItem<String>(
        value: tml.identifier,
        label: tml.title.isNotEmpty ? tml.title : tml.identifier,
        selected: template.versionOfUri == tml.identifier,
      );
    }).toList();
  }

  List<DropdownItem<String>> getSchemaItems() {
    return schemas.map((schema) {
      return DropdownItem<String>(
        value: schema.identifier,
        label: schema.title.isNotEmpty ? schema.title : schema.identifier,
        selected: template.schemaUri == schema.identifier,
      );
    }).toList();
  }

  List<DropdownItem<String>> getLanguageItems() {
    return languages.map((lang) {
      return DropdownItem<String>(
        value: lang.code,
        label: lang.name.isNotEmpty ? lang.name : lang.code,
        selected: template.language == lang.code,
      );
    }).toList();
  }

  List<DropdownItem<String>> getSchemaConceptItems() {
    return template.schemaUri.isNotEmpty
        ? schemas
            .firstWhere((s) => s.identifier == template.schemaUri)
            .concepts
            .map((concept) => DropdownItem<String>(
                  value: concept.name,
                  label: concept.name,
                  selected: conceptNameForDefaultScenarios == concept.name,
                ))
            .toList()
        : [];
  }
}