import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/manager_selector.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertOrganizationWindow {
  final XOrganization organization;
  final List<XPerson> _peopleResources;
  final List<XContactData> _existingContacts;
  late XUserAccount _currentUserAccount;
  late XAgent? _currentAgent;

  late bool isInsert;

  List<XContactData> newContacts = [];
  int newContactsCounter = 0;

  MUpsertOrganizationWindow(
      this.organization, this._peopleResources, this._existingContacts,
      this._currentUserAccount, this._currentAgent);

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = organization.identifier.isEmpty;
  }

  bool isUserAgentAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.AgentAdmin);
  }

  // **** Organization ****

  // Identifiers
  String createOrganizationIdentifier(String name){
    return MUriGenerator.generateUriFromResource(organization, name);
  }

  // Roles
  void updateRoles(List<ManagerAssignment> assignments){
    organization.membersRoles = assignments.asMap().map((index, value) 
      => MapEntry(value.agent.identifier, value.roles));
  }

  void updateMemberUris(List<ManagerAssignment> assignments){
    organization.membersUris = assignments.map((e) => e.agent.identifier).toList();
  }

  bool isUserAllowedToEditMembers() {
    return organization.userRoles.contains(ManagerRole.AgentManager) || isUserAgentAdmin();
  }

  bool isUserMetadataManager() {
    return organization.userRoles.contains(ManagerRole.MetadataManager);
  }

  void refreshUserRoles() {
    if (organization.membersUris.contains(_currentAgent?.identifier)) {
      organization.userRoles = (null != organization.membersRoles[_currentAgent!.identifier])
        ? List.from(organization.membersRoles[_currentAgent!.identifier]!) 
        : [];
    }
  }

  // Members
  void removeMember(String memberId) {
    //if (organization.managersUris.contains(memberId)) {
    //  organization.managersUris.remove(memberId);
    //}
    //organization.membersUris.remove(memberId);
    //_membersResources.removeWhere((m) => m.identifier == memberId);
  }

  Map<String, String> getMembersMap() {
    return {
      for (var person in _peopleResources.where((p) => organization.membersUris.contains(p.identifier)))
        person.identifier: "${person.givenNames.first} ${person.familyName}"
    };
  }

  bool isMemberAlreadyAdded(String memberId) {
    return organization.membersUris.contains(memberId);
  }

  // **** Contacts ****

  // Getters
  Set<XContactData> getContactOptions(){
    return {
      ..._existingContacts,
      ...newContacts,
    };
  }

  // Setters
  void addToNewContacts(String name, String contents) {
    // Create a new contact with a unique identifier
    newContacts.add(XContactData()
      ..identifier = _createContactIdentifier(newContactsCounter++)
      ..name = name
      ..contents = contents
    );
    refreshContactsCounter(resetCounter: false);
  }

  /// Returns a counter for all current non-agent contacts
  void refreshContactsCounter({bool excludeNewContacts = false, bool resetCounter = true}) {
    Set<XContactData> aggregatedContacts = excludeNewContacts ? _existingContacts.toSet() : {
      ..._existingContacts,
      ...newContacts,
    };
    int counter = resetCounter ? 0 : newContactsCounter;
    while (aggregatedContacts.any((c) => _createContactIdentifier(counter) == c.identifier)) {
      counter++;
    }
    this.newContactsCounter = counter;
  }

  // Identifiers
  String _createContactIdentifier(int counter){
    return MUriGenerator.generateUriFromContact(organization, counter);
  }

  void updateNewContactsIdentifiers(){
    refreshContactsCounter(excludeNewContacts: true);
    newContacts.forEach((contact) {
      contact.identifier = _createContactIdentifier(newContactsCounter++);
      refreshContactsCounter(excludeNewContacts: true, resetCounter: false);
    });
  }

  // Validators
  bool isContactNew(String name, String content) {
    return !newContacts.any((contact) =>
        contact.contents == content &&
        contact.name == name);
  }

  // Delete
  void removeExistingContact(XContactData contact){
    organization.contactsUris.removeWhere((c) => c == contact.identifier);
    _existingContacts.remove(contact);
  }

  // **** Options for dropdowns ****

  Map<String, List<ManagerRole>> getRoleAssignments() {
    Map<String, List<ManagerRole>> roles = organization.membersRoles;

    if (organization.membersUris.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in organization.membersUris)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  List<XPerson> getAvailableMembers() {
    return _peopleResources;
  }

  List<DropdownItem<String>> getPeopleOptions() {
    return _peopleResources.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.first} ${person.familyName}",
      );
    }).toList();
  }

  List<DropdownItem<String>> getManagersOptions() {

    Iterable<XPerson> selectedMembers = _peopleResources.where((p) => organization.membersUris.contains(p.identifier));

    return selectedMembers.map((person) {
      //final isSelected = organization.managersUris.any((p) => p == person.identifier);

        return DropdownItem<String>(
          value: person.identifier,
          label: "${person.givenNames.first} ${person.familyName}",
          //selected: isSelected,
        );
      }).toList();
  }
}
