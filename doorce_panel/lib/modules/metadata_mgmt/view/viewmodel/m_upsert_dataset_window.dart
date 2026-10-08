import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertDatasetWindow {
  late XDataset dataset;
  final List<Language> _languageResources;
  final List<Licence> _licenceResources;
  final List<DatasetTheme> _themeResources;
  final List<Frequency> _frequencyResources;
  late List<XCatalogue> agentCatalogsResources;
  late List<XPerson> _peopleResources;
  late List<XOrganization> _organizationResources;
  late List<XDatasetSeries> agentSeriesResources;
  late List<XContactData> _existingContacts; // Contacts that are already associated with the dataset, both agent and non-agent contacts
  late List<XDataSchema> _schemaResources;
  late XUserAccount _currentUserAccount;
  late XAgent? currentAgent;
  late List<XDataset> targetDatasetResources;
  late Map<String, int>? itemCountsByConcept;

  late List<XContactData> datasetAgentsContacts = []; // all contact options for selected agents (person, organization, editors)
  late List<XContactData> newContacts = [];  // New contacts to be added, non-agent
  late int nonAgentContactsCounter = 0; // Counter for non-agent contacts, used to generate unique identifiers

  late bool isInsert;
  late bool isPreview;

  bool createDefaultApp = false;

  MUpsertDatasetWindow(
    this._languageResources,
    this._licenceResources,
    this._themeResources,
    this._frequencyResources,
  );

  void init(
      XDataset dataset,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<XDatasetSeries> agentSeriesResources,
      List<XContactData> existingContacts,
      List<XDataSchema> schemaResources,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      List<XDataset> targetDatasetResources,
      Map<String, int>? itemCountsByConcept,
      bool? preview) {
    this.dataset = dataset;
    this.agentCatalogsResources = agentCatalogsResources;
    this._peopleResources = peopleResources;
    this._organizationResources = organizationResources;
    this.agentSeriesResources = agentSeriesResources;
    this._existingContacts = existingContacts;
    this._schemaResources = schemaResources;
    this._currentUserAccount = currentUserAccount;
    this.currentAgent = currentAgent;
    this.targetDatasetResources = targetDatasetResources;
    this.itemCountsByConcept = itemCountsByConcept;
    this.isPreview = preview ?? false;
  }

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = dataset.identifier.isEmpty;
  }

  bool isUserDataAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.DataAdmin);
  }

  bool isMetadataEditable() {
    return !isPreview && isUserMetadataEditor();
  }

  bool isStatusEditable() {
    return isMetadataEditable() && (isInsert || dataset.status != DatasetStatus.independent);
  }

  bool canCreateDefaultApp() {
    return isInsert && dataset.schemaID != null && dataset.schemaID!.isNotEmpty && dataset.status != DatasetStatus.independent;
  }

  void refreshCreateDefaultApp() {
    if (!canCreateDefaultApp()) {
      createDefaultApp = false;
    }
  }

  // **** Dataset methods ****

  // Setters
  void updateDatasetReleaseDate([DateTime? releaseDate]) {
    if (releaseDate != null) {
      dataset.releaseDate = releaseDate;
    } else {
      dataset.releaseDate = DateTime.now();
    }
  }

  void updateDatasetIcon(String? iconUri, Uint8List? icon) {
    dataset.iconUri = iconUri;
    dataset.icon = icon;
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      dataset.editorIDList.add(currentAgent!.identifier);
      dataset.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

  void refreshTargetDatasetId(List<XDataset> datasets) {
    if (!datasets.any((d) => d.identifier == dataset.targetDatasetID)) {
      dataset.targetDatasetID = null;
    }
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    dataset.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    dataset.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  bool isEditorsEditable() {
    return !isPreview && dataset.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isUserMetadataEditor() {
    return dataset.userRoles.contains(EditorRole.MetadataEditor);
  }

  void refreshUserRoles() {
    if (dataset.editorIDList.contains(currentAgent?.identifier)) {
      List<EditorRole> userRoles = (null != dataset.editorRoles[currentAgent!.identifier])
        ? List.from(dataset.editorRoles[currentAgent!.identifier]!) 
        : [];

      List<EditorRole> parentUserRoles = agentCatalogsResources.firstWhere((cat) => dataset.catalogueID == cat.identifier).userRoles;
      userRoles.addAll(parentUserRoles);
      userRoles.toSet().toList();
      dataset.userRoles = userRoles;
    }
  }

  // Identifiers
  String createDatasetIdentifier(String title){
    return MUriGenerator.generateUriFromResource(dataset, title);
  }

  // Getters
  XDataset getDataset(BuildContext context) {
    return dataset;
  }

  Iterable<String> getDatasetMetadataLanguages() {
    return dataset.title.keys;
  }

  // Checks 
  bool isDatasetTitlesEmpty() {
    return dataset.title.isEmpty ||
        dataset.title.values.every((title) => title.isEmpty);
  }

  bool isDatasetDescriptionsEmpty() {
    return dataset.description.isEmpty ||
        dataset.description.values.every((description) => description.isEmpty);
  }

  bool areResponsibleAgentsNullOrEmpty() {
    return (null == dataset.responsibleOrganisationID || dataset.responsibleOrganisationID!.isEmpty)
      && (null == dataset.responsiblePersonID || dataset.responsiblePersonID!.isEmpty);
  }

  bool hasItems() {
    return itemCountsByConcept != null && itemCountsByConcept!.values.any((c) => c > 0);
  }

  bool isIndependent() {
    return dataset.status == DatasetStatus.independent;
  }

  // **** Contacts ****

  Set<String> getAvailableContactIds() {
    return {
      ...datasetAgentsContacts.map((c) => c.identifier),
      ...newContacts.map((c) => c.identifier),
      ..._existingContacts.where((c) => c.agentID == null).map((c) => c.identifier),
    };
  }

  // Setters
  void addToNewContacts(String name, String contents) {
    // Create a new contact with a unique identifier
    newContacts.add(XContactData()
      ..identifier = _createContactIdentifier(nonAgentContactsCounter++)
      ..name = name
      ..contents = contents
    );
    refreshContactsCounter(resetCounter: false);
  }

  void updateContactsOnSelection(List<String> selectedContactIds) {
    // Build a set of all currently available contact IDs
    final availableContactIds = getAvailableContactIds();

    // Only keep selected IDs that are still available
    dataset.contactIDList = selectedContactIds.where((id) => availableContactIds.contains(id) 
      && !newContacts.any((nc) => id == nc.identifier)).toList();

    // Remove new contacts that are no longer selected
    newContacts.removeWhere((c) => !selectedContactIds.contains(c.identifier));
  }

  void refreshContactResources(List<XContactData> contactResources) {
    this.datasetAgentsContacts = contactResources;

    final availableContactIds = getAvailableContactIds();

    // Only keep selected IDs that are still available
    dataset.contactIDList = dataset.contactIDList.where((id) => availableContactIds.contains(id)).toList();
  }

  // Identifiers
  String _createContactIdentifier(int counter){
    return MUriGenerator.generateUriFromContact(dataset, counter);
  }

  void updateNewContactsIdentifiers(){
    refreshContactsCounter(excludeNewContacts: true);
    newContacts.forEach((contact) {
      contact.identifier = _createContactIdentifier(nonAgentContactsCounter++);
      refreshContactsCounter(excludeNewContacts: true, resetCounter: false);
    });
  }

  /// Returns a counter for all current non-agent contacts
  void refreshContactsCounter({bool excludeNewContacts = false, bool resetCounter = true}) {
    Set<XContactData> aggregatedContacts = excludeNewContacts ? _existingContacts.toSet() : {
      ..._existingContacts,
      ...newContacts,
    };
    int counter = resetCounter ? 0 : nonAgentContactsCounter;
    while (aggregatedContacts.any((c) => _createContactIdentifier(counter) == c.identifier)) {
      counter++;
    }
    this.nonAgentContactsCounter = counter;
  }

  // Getters
  List<XContactData> getNewContacts() {
    return newContacts;
  }

  // Validators
  bool isContactNew(String name, String content) {
    return !newContacts.any((contact) =>
        contact.contents == content &&
        contact.name == name);
  }

  // **** Options for dropdowns ****

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = dataset.editorRoles;

    if (dataset.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in dataset.editorIDList)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  List<XAgent> getAvailableAgents() {
    return [
      ..._peopleResources,
      ..._organizationResources,
    ];
  }

  List<DropdownItem<String>> getContactOptions() {
    final combinedContacts = {
      ..._existingContacts.where((c) => null == c.agentID),
      ...datasetAgentsContacts,
      ...newContacts, // New contacts that are not yet associated with the dataset, non-agent
    };

    return combinedContacts.map((contact) {
      final isSelected =
              newContacts.any((c) => c.identifier == contact.identifier) ||
              dataset.contactIDList.any((c) => c == contact.identifier);

      return DropdownItem<String>(
        value: contact.identifier,
        label:
            "${contact.agentName ?? ""} (${"${contact.name}: ${contact.contents}"})",
        selected: isSelected,
      );
    }).toList();
  }

  List<DropdownItem<DatasetType>> getDatasetTypeOptions(BuildContext context) {
    return DatasetType.values.map((type) {
      return DropdownItem<DatasetType>(
        value: type,
        label:
            type.getText(context, Localizations.localeOf(context).toString()),
        selected: dataset.type.contains(type.index)
      );
    }).toList();
  }

  List<DropdownItem<DatasetStatus>> getDatasetStatusOptions(BuildContext context) {
    var statuses = DatasetStatus.values.map((status) {
      return DropdownItem<DatasetStatus>(
        value: status,
        label:
            status.getText(context, Localizations.localeOf(context).toString()),
        selected: status == dataset.status
      );
    }).toList();

    if (!isInsert && dataset.status != DatasetStatus.independent) {
      statuses.removeWhere((status) => status.value == DatasetStatus.independent);
    }

    return statuses;
  }

  List<DropdownItem<AccessRightTypes>> getAccessRightOptions(
      BuildContext context) {
    return AccessRightTypes.values.map((accessRight) {
      return DropdownItem<AccessRightTypes>(
        value: accessRight,
        label: accessRight.getText(
            context, Localizations.localeOf(context).toString()),
        selected: accessRight.index == dataset.accessRights
      );
    }).toList();
  }

  List<DropdownItem<String>> getCatalogsOptions(BuildContext context) {
    return agentCatalogsResources.map((catalog) {
      return DropdownItem<String>(
        value: catalog.identifier,
        label: catalog.title[Localizations.localeOf(context).languageCode] ??
            catalog.title["en"] ??
            catalog.title.values.first,
        selected: catalog.identifier == dataset.catalogueID
      );
    }).toList();
  }

  List<DropdownItem<String>> getSeriesOptions(BuildContext context) {
    return agentSeriesResources.map((series) {
      return DropdownItem<String>(
        value: series.identifier,
        label: series.title[Localizations.localeOf(context).languageCode] ??
            series.title["en"] ??
            series.title.values.first,
        selected: dataset.seriesID.contains(series.identifier)
      );
    }).toList();
  }

  List<DropdownItem<String>> getMetadataLanguageOptions(String? selectedMetadataLanguageCode) {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: language.code == selectedMetadataLanguageCode
      );
    }).toList();
  }

  List<DropdownItem<String>> getLanguageOptions() {
    return _languageResources.map((language) {
      return DropdownItem<String>(
        value: language.code,
        label: language.name,
        selected: dataset.languages.contains(language.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getLicenceOptions() {
    return _licenceResources.map((licence) {
      return DropdownItem<String>(
        value: licence.code,
        label: licence.label,
        selected: dataset.licence.contains(licence.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getThemeOptions() {
    return _themeResources.map((theme) {
      return DropdownItem<String>(
        value: theme.code,
        label: theme.label,
        selected: dataset.themes.contains(theme.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getFrequencyOptions() {
    return _frequencyResources.map((frequency) {
      return DropdownItem<String>(
        value: frequency.code,
        label: frequency.label,
        selected: frequency.code == dataset.frequency
      );
    }).toList();
  }

  List<DropdownItem<String>> getPeopleOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: person.identifier == dataset.responsiblePersonID
      );
    }).toList();
  }

  List<DropdownItem<String>> getEditorOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: dataset.editorIDList.any((id) => id == person.identifier)
      );
    }).toList();
  }

  List<DropdownItem<String>> getOrganizationsOptions() {
    return _organizationResources.map((organization) {
      return DropdownItem<String>(
        value: organization.identifier,
        label: organization.name,
        selected: organization.identifier == dataset.responsibleOrganisationID
      );
    }).toList();
  }

  List<DropdownItem<XDataSchema>> getSchemaOptions() {
    return _schemaResources.map((schema) {
      return DropdownItem<XDataSchema>(
          value: schema, 
          label: "${schema.seriesTitle}: ${schema.title}",
          selected: schema.identifier == (dataset.schemaID ?? false));
    }).toList();
  }

  List<DropdownItem<String>> getTargetDatasetOptions(BuildContext context) {
    List<XDataset> tempList = List.from(targetDatasetResources);
    tempList.removeWhere((d) => d.identifier == dataset.identifier);

    return tempList.map((targetDataset) {
      return DropdownItem<String>(
          value: targetDataset.identifier, 
          label: targetDataset.title[Localizations.localeOf(context).languageCode] ??
            targetDataset.title["en"] ??
            targetDataset.title.values.first,
          selected: targetDataset.identifier == (dataset.targetDatasetID ?? false));
    }).toList();
  }
}
