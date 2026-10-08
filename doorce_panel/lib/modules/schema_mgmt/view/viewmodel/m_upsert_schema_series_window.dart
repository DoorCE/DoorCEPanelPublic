import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertSchemaSeriesWindow {
  final XSchemaSeries series;
  final List<XDataSchema> _schemaResources;
  final List<XPerson> peopleResources;
  final List<XOrganization> organizationResources;
  late XUserAccount _currentUserAccount;
  final XAgent? currentAgent;

  late bool isInsert;
  late bool isPreview;

  MUpsertSchemaSeriesWindow(
      this.series,
      this._schemaResources,
      this.peopleResources,
      this.organizationResources,
      this._currentUserAccount,
      this.currentAgent,
      isPreview
      ){
        this.isPreview = isPreview ?? false;
      }

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = series.identifier.isEmpty;
  }

  bool isUserDataAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.DataAdmin);
  }

  bool isMetadataEditable() {
    return !isPreview && isUserMetadataEditor();
  }

  // **** Schema Series ****

  String createSeriesIdentifier(String title){
    return MUriGenerator.generateUriFromResource(series, title);
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    series.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    series.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      series.editorIDList.add(currentAgent!.identifier);
      series.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

  bool isEditorsEditable() {
    return !isPreview && series.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isUserMetadataEditor() {
    return series.userRoles.contains(EditorRole.MetadataEditor);
  }

  void refreshUserRoles() {
    if (series.editorIDList.contains(currentAgent?.identifier)) {
      series.userRoles = (null != series.editorRoles[currentAgent!.identifier])
        ? List.from(series.editorRoles[currentAgent!.identifier]!) 
        : [];
    }
  }

  // **** Options for dropdowns ****

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = series.editorRoles;

    if (series.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in series.editorIDList)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  List<XAgent> getAvailableAgents() {
    return [
      ...peopleResources,
      ...organizationResources,
    ];
  }

  List<DropdownItem<XDataSchema>> getSchemaOptions(
      BuildContext context) {
    return _schemaResources.map((schema) {
      return DropdownItem<XDataSchema>(
        value: schema,
        label: schema.title,
        selected: series.currentSchemaUri == schema.identifier
      );
    }).toList();
  }

  List<DropdownItem<DatasetType>> getDatasetTypeOptions(BuildContext context) {
    return DatasetType.values
        .map((dt) => DropdownItem<DatasetType>(
              value: dt,
              label: dt.getText(context, Localizations.localeOf(context).languageCode),
              selected: series.type.contains(dt.index)
            ))
        .toList();
  }
}