import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/common/types/access_status.dart';
import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertServiceWindow {
  late XDatasetService service;
  final List<Language> _languageResources;
  final List<Licence> _licenceResources;
  final List<DatasetTheme> _themeResources;
  late List<XCatalogue> _agentCatalogsResources;
  late List<XPerson> _peopleResources;
  late List<XOrganization> _organizationResources;
  final List<String> _formatResources;
  late List<XContactData> _existingContacts;
  late XUserAccount _currentUserAccount;
  late XAgent? currentAgent;

  late List<XContactData> datasetAgentsContacts = []; // all contact options for selected agents (person, organization, editors)
  late List<XContactData> newContacts = [];  // New contacts to be added, non-agent
  late int nonAgentContactsCounter = 0; // Counter for non-agent contacts, used to generate unique identifiers

  late bool isInsert;
  late bool isPreview;

  MUpsertServiceWindow(
    this._languageResources,
    this._licenceResources,
    this._themeResources,
    this._formatResources,
  );

  void init(
      XDatasetService service,
      List<XCatalogue> agentCatalogsResources,
      List<XPerson> peopleResources,
      List<XOrganization> organizationResources,
      List<XContactData> existingContacts,
      XUserAccount currentUserAccount,
      XAgent? currentAgent,
      [bool? isPreview]) {
    this.service = service;
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
    this.isInsert = service.identifier.isEmpty;
  }

  bool isUserDataAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.DataAdmin);
  }

  bool isMetadataEditable() {
    return !isPreview && isUserMetadataEditor();
  }

  // **** Service methods ****

  // Setters
  void updateServiceIcon(String? iconUri, Uint8List? icon) {
    service.iconUri = iconUri;
    service.icon = icon;
  }

  void setCurrentAgentAsEditor() {
    if (null != currentAgent) {
      service.editorIDList.add(currentAgent!.identifier);
      service.editorRoles[currentAgent!.identifier] = [EditorRole.MetadataEditor, EditorRole.OwnershipEditor];
    }
  }

  // Roles
  void updateRoles(List<EditorAssignment> assignments){
    service.editorRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.editor.identifier, value.roles));
  }

  void updateEditorUris(List<EditorAssignment> assignments){
    service.editorIDList = assignments.map((e) => e.editor.identifier).toList();
  }

  bool isEditorsEditable() {
    return !isPreview && service.userRoles.contains(EditorRole.OwnershipEditor);
  }

  bool isUserMetadataEditor() {
    return service.userRoles.contains(EditorRole.MetadataEditor);
  }

  void refreshUserRoles() {
    if (service.editorIDList.contains(currentAgent?.identifier)) {
      List<EditorRole> userRoles = (null != service.editorRoles[currentAgent!.identifier])
        ? List.from(service.editorRoles[currentAgent!.identifier]!) 
        : [];

      List<EditorRole> parentUserRoles = _agentCatalogsResources.firstWhere((cat) => service.catalogueID == cat.identifier).userRoles;
      userRoles.addAll(parentUserRoles);
      userRoles.toSet().toList();
      service.userRoles = userRoles;
    }
  }

  // Identifiers
  String createServiceIdentifier(String title){
    return MUriGenerator.generateUriFromResource(service, title);
  }

  // Empty checks 
  bool isServiceTitlesEmpty() {
    return service.title.isEmpty ||
        service.title.values.every((title) => title.isEmpty);
  }

  bool isServiceDescriptionsEmpty() {
    return service.description.isEmpty ||
        service.description.values.every((description) => description.isEmpty);
  }

  bool areResponsibleAgentsNullOrEmpty() {
    return (null == service.responsibleOrganisationID || service.responsibleOrganisationID!.isEmpty)
      && (null == service.responsiblePersonID || service.responsiblePersonID!.isEmpty);
  }

  // Validators
  bool isContactNew(String name, String content) {
    return !newContacts.any((contact) =>
        contact.contents == content &&
        contact.name == name);
  }

  // **** Contacts ****

  // Getters
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
    service.contactIDList = selectedContactIds.where((id) => availableContactIds.contains(id) 
      && !newContacts.any((nc) => id == nc.identifier)).toList();

    // Remove new contacts that are no longer selected
    newContacts.removeWhere((c) => !selectedContactIds.contains(c.identifier));
    }

  void refreshContactResources(List<XContactData> contactResources) {
    this.datasetAgentsContacts = contactResources;

    final availableContactIds = getAvailableContactIds();

    // Only keep selected IDs that are still available
    service.contactIDList = service.contactIDList.where((id) => availableContactIds.contains(id)).toList();
  }

  // Identifiers
  String _createContactIdentifier(int counter){
    return MUriGenerator.generateUriFromContact(service, counter);
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

  // **** Options for dropdowns ****

  Map<String, List<EditorRole>> getRoleAssignments() {
    Map<String, List<EditorRole>> roles = service.editorRoles;

    if (service.editorIDList.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in service.editorIDList)
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
      ...datasetAgentsContacts,
      ...newContacts,
    };

    return combinedContacts.map((contact) {
      final isSelected =
        newContacts.any((c) => c.identifier == contact.identifier) ||
        service.contactIDList.any((c) => c == contact.identifier);

      return DropdownItem<String>(
        value: contact.identifier,
        label: "${contact.agentName ?? ""} (${"${contact.name}: ${contact.contents}"})",
        selected: isSelected,
      );
    }).toList();
  }

  List<DropdownItem<AccessRightTypes>> getAccessRightOptions(
      BuildContext context) {
    return AccessRightTypes.values.map((accessRight) {
      return DropdownItem<AccessRightTypes>(
        value: accessRight,
        label: accessRight.getText(
            context, Localizations.localeOf(context).toString()),
        selected: accessRight.index == service.accessRights
      );
    }).toList();
  }

  List<DropdownItem<String>> getCatalogsOptions(BuildContext context) {
    return _agentCatalogsResources.map((catalog) {
      return DropdownItem<String>(
        value: catalog.identifier,
        label: catalog.title[Localizations.localeOf(context).languageCode] ??
            catalog.title["en"] ??
            catalog.title.values.first,
        selected: catalog.identifier == service.catalogueID
      );
    }).toList();
  }

  List<DropdownItem<AccessStatus>> getAccessStatusOptions(
      BuildContext context) {
    return AccessStatus.values.map((status) {
      return DropdownItem<AccessStatus>(
        value: status,
        label:
            status.getText(context, Localizations.localeOf(context).toString()),
        selected: service.status == status.index
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
        selected: service.languages.contains(language.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getLicenceOptions() {
    return _licenceResources.map((licence) {
      return DropdownItem<String>(
        value: licence.code,
        label: licence.label,
        selected: service.licence.contains(licence.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getThemeOptions() {
    return _themeResources.map((theme) {
      return DropdownItem<String>(
        value: theme.code,
        label: theme.label,
        selected: service.themes.contains(theme.code)
      );
    }).toList();
  }

  List<DropdownItem<String>> getPeopleOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: service.responsiblePersonID == person.identifier
      );
    }).toList();
  }

  List<DropdownItem<String>> getOrganizationsOptions() {
    return _organizationResources.map((organization) {
      return DropdownItem<String>(
        value: organization.identifier,
        label: organization.name,
        selected: service.responsibleOrganisationID == organization.identifier
      );
    }).toList();
  }

  List<DropdownItem<String>> getEditorOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
        selected: service.editorIDList.contains(person.identifier)
      );
    }).toList();
  }

  List<DropdownItem<String>> getFormatOptions() {
    return _formatResources.map((format) {
      return DropdownItem<String>(
        value: format,
        label: format,
        selected: service.format.contains(format)
      );
    }).toList();
  }
}
