import 'dart:typed_data';

import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertCatalogueWindow {
  late XCatalogue catalogue;
  final List<Language> _languageResources;
  late List<XCatalogue> _agentCatalogsResources;
  late List<XPerson> _peopleResources;
  late List<XOrganization> _organizationResources;
  late List<XContactData> _existingContacts;
  late XUserAccount _currentUserAccount; // agent + non-agent
  late XAgent? currentAgent;

  late List<XContactData> catalogueAgentsContacts = []; // all contact options for selected agents (person, organization, editors)
  late List<XContactData> newContacts = [];  // New contacts to be added, non-agent
  late int nonAgentContactsCounter = 0; // Counter for non-agent contacts, used to generate unique identifiers

  late bool isInsert;
  late bool isPreview;

  MUpsertCatalogueWindow(this._languageResources);

  void init(
      XCatalogue catalogue,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<XContactData> existingContacts,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      bool? isPreview) {
    this.catalogue = catalogue;
    this._agentCatalogsResources = agentCatalogsResources;
    this._peopleResources = peopleResources;
    this._organizationResources = organizationResources;
    this._existingContacts = existingContacts;
    this._currentUserAccount = currentUserAccount;
    this.currentAgent = currentAgent;
    this.isPreview = isPreview ?? false;
  }

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = catalogue.identifier.isEmpty;
  }

  bool isUserDataAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.DataAdmin);
  }

  bool isMetadataEditable() {
    return !isPreview && isUserMetadataEditor();
  }

  // **** Catalogue methods ****

  // Setters
  void updateCatalogueIcon(String? iconUri, Uint8List? icon) {
    catalogue.iconUri = iconUri;
    catalogue.icon = icon;
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    catalogue.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    catalogue.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      catalogue.editorIDList.add(currentAgent!.identifier);
      catalogue.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

  bool isEditorsEditable() {
    return !isPreview && catalogue.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isUserMetadataEditor() {
    return catalogue.userRoles.contains(EditorRole.MetadataEditor);
  }

  void refreshUserRoles() {
    if (catalogue.editorIDList.contains(currentAgent?.identifier)) {
      List<EditorRole> userRoles = (null != catalogue.editorRoles[currentAgent!.identifier])
        ? List.from(catalogue.editorRoles[currentAgent!.identifier]!) 
        : [];

      List<EditorRole> parentUserRoles = _agentCatalogsResources.firstWhere((cat) => catalogue.parentID == cat.identifier).userRoles;
      userRoles.addAll(parentUserRoles);
      userRoles.toSet().toList();
      catalogue.userRoles = userRoles;
    }
  }

  // Identifiers
  String createCatalogueIdentifier(String title){
    return MUriGenerator.generateUriFromResource(catalogue, title);
  }
  
  // Empty checks 
  bool isCatalogueTitlesEmpty() {
    return catalogue.title.isEmpty ||
        catalogue.title.values.every((title) => title.isEmpty);
  }

  bool isCatalogueDescriptionsEmpty() {
    return catalogue.description.isEmpty ||
        catalogue.description.values.every((description) => description.isEmpty);
  }

  bool areResponsibleAgentsNullOrEmpty() {
    return (null == catalogue.responsibleOrganisationID || catalogue.responsibleOrganisationID!.isEmpty)
      && (null == catalogue.responsiblePersonID || catalogue.responsiblePersonID!.isEmpty);
  }

  // **** Contacts ****

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

  void refreshContactResources(List<XContactData> contactResources) {
    this.catalogueAgentsContacts = contactResources;

    final availableContactIds = getAvailableContactIds();

    // Only keep selected IDs that are still available
    catalogue.contactIDList = catalogue.contactIDList.where((id) => availableContactIds.contains(id)).toList();
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

  void updateContactsOnSelection(List<String> selectedContactIds) {
    // Build a set of all currently available contact IDs
    final availableContactIds = getAvailableContactIds();

    // Only keep selected IDs that are still available
    catalogue.contactIDList = selectedContactIds.where((id) => availableContactIds.contains(id) 
      && !newContacts.any((nc) => id == nc.identifier)).toList();

    // Remove new contacts that are no longer selected
    newContacts.removeWhere((c) => !selectedContactIds.contains(c.identifier));
    }

  // Getters
  Set<String> getAvailableContactIds() {
    return {
      ...catalogueAgentsContacts.map((c) => c.identifier),
      ...newContacts.map((c) => c.identifier),
      ..._existingContacts.where((c) => c.agentID == null).map((c) => c.identifier),
    };
  }

  // Identifiers
  String _createContactIdentifier(int counter){
    return MUriGenerator.generateUriFromContact(catalogue, counter);
  }

  void updateNewContactsIdentifiers(){
    refreshContactsCounter(excludeNewContacts: true);
    newContacts.forEach((contact) {
      contact.identifier = _createContactIdentifier(nonAgentContactsCounter++);
      refreshContactsCounter(excludeNewContacts: true, resetCounter: false);
    });
  }

  // Validators
  bool isContactNew(String name, String content) {
    return !newContacts.any((contact) =>
        contact.contents == content &&
        contact.name == name);
  }

  // **** Options for dropdowns ****

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = catalogue.editorRoles;

    if (catalogue.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in catalogue.editorIDList)
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

  List<DropdownItem<String>> getContactOptions(){
    final combinedContacts = {
      ..._existingContacts.where((c) => null == c.agentID),
      ...catalogueAgentsContacts,
      ...newContacts,
    };

    return combinedContacts.map((contact) {
      final isSelected =
        newContacts.any((c) => c.identifier == contact.identifier) ||
        catalogue.contactIDList.any((c) => c == contact.identifier);

      return DropdownItem<String>(
        value: contact.identifier,
        label: "${contact.agentName ?? ""} (${"${contact.name}: ${contact.contents}"})",
        selected: isSelected,
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

  List<DropdownItem<String>> getCatalogsOptions(BuildContext context) {
    return _agentCatalogsResources.map((parentCatalog) {
      return DropdownItem<String>(
        value: parentCatalog.identifier,
        label: parentCatalog.title[Localizations.localeOf(context).languageCode] ??
            parentCatalog.title["en"] ??
            parentCatalog.title.values.first,
        selected: parentCatalog.identifier == catalogue.parentID
      );
    }).toList();
  }

  List<DropdownItem<String>> getPeopleOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: person.identifier == catalogue.responsiblePersonID
      );
    }).toList();
  }

  List<DropdownItem<String>> getEditorOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: catalogue.editorIDList.any((id) => id == person.identifier)
      );
    }).toList();
  }

  List<DropdownItem<String>> getOrganizationsOptions() {
    return _organizationResources.map((organization) {
      return DropdownItem<String>(
        value: organization.identifier,
        label: organization.name,
        selected: organization.identifier == catalogue.responsibleOrganisationID
      );
    }).toList();
  }
}
