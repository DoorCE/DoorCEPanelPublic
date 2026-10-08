import 'package:doorce_panel/common/types/app_status.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/source_creation_request.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertAppWindow {
  final XApp app;
  final List<XAppTemplate> templates;
  late List<XDataset> datasets;
  final List<XAgent> agents;
  final List<XCatalogue> catalogues;
  late XUserAccount _currentUserAccount;
  late XAgent? currentAgent;

  late List<XSourceCreationRequest> newResources = List.empty(growable: true);
  late String? selectedCatalogueUri = null;
  late bool isInsert;
  late bool isPreview;

  MUpsertAppWindow(
      this.app,
      this.templates,
      this.datasets,
      this.agents,
      this.catalogues,
      this._currentUserAccount,
      this.currentAgent,
      bool? isPreview
      ) {
        this.isPreview = isPreview ?? false;
      }

// ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = app.identifier.isEmpty;
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
    return app.userRoles.contains(EditorRole.MetadataEditor);
  }

  bool isUserOwnershipEditor() {
    return app.userRoles.contains(EditorRole.OwnershipEditor);
  }

  void refreshUserRoles() {
    if (app.editorIDList.contains(currentAgent?.identifier)) {
      app.userRoles = (null != app.editorRoles[currentAgent!.identifier])
        ? List.from(app.editorRoles[currentAgent!.identifier]!) 
        : [];
    }
  }

// ------------------------ RESOURCES ------------------------------------------
  void refreshDatasets(List<XDataset> datasets) {
    this.datasets = datasets;
  }

// ------------------------ APP -----------------------------------------------

  String createAppIdentifier(String title) {
    return MUriGenerator.generateUriFromResource(app, title);
  }

  bool canEditApp() {
    return isInsert || (isMetadataEditable() && app.status == AppStatus.Created);
  }

// ------------------------ APP EDITORS ---------------------------------------

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = app.editorRoles;

    if (app.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in app.editorIDList)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    app.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    app.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      app.editorIDList.add(currentAgent!.identifier);
      app.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

//------------------------- OPTIONS FOR DROPDOWNS -----------------------------

  List<DropdownItem<String>> getTemplateItems() {
    return templates.map((template) {
      return DropdownItem<String>(
        value: template.identifier,
        label: template.title.isNotEmpty ? template.title : template.identifier,
        selected: app.templateUri == template.identifier,
      );
    }).toList();
  }

  List<DropdownItem<String>> getActiveResourceItems(BuildContext context) {
    return datasets.map((dataset) {
      return DropdownItem<String>(
        value: dataset.identifier,
        label: dataset.title[Localizations.localeOf(context).languageCode] ??
            dataset.title["en"] ??
            dataset.title.values.first,
        selected: app.activeResourceUri == dataset.identifier,
      );
    }).toList();
  }

  List<DropdownItem<String>> getSourceResourceItems(BuildContext context) {
    var newDatasets = newResources.map((dataset) {
      return DropdownItem<String>(
        value: dataset.sourceDatasetName,
        label: "${AppLocalizations.of(context)!.newField}: ${dataset.sourceDatasetName}",
        selected: true,
      );
    }).toList();
    
    var existingDatasets = datasets.where((ds) => ds.status == DatasetStatus.source)
      .map((dataset) {
        return DropdownItem<String>(
          value: dataset.identifier,
          label: dataset.title[Localizations.localeOf(context).languageCode] ??
              dataset.title["en"] ??
              dataset.title.values.first,
          selected: app.sourceResourceUris.contains(dataset.identifier),
        );
      }).toList();
    return [...newDatasets, ...existingDatasets];
  }

  void handleResourceItemSelection(List<String> selectedValues) {
    List<XSourceCreationRequest> selectedNewResources = [];
    List<String> selectedExistingResourceUris = [];

    for (var value in selectedValues) {
      if (datasets.any((ds) => ds.identifier == value)) {
        selectedExistingResourceUris.add(value);
      } else {
        var newResource = newResources.firstWhere(
        (res) => res.sourceDatasetName == value);
        selectedNewResources.add(newResource);
      }
    }

    newResources = selectedNewResources;
    app.sourceResourceUris = selectedExistingResourceUris;
  }

}