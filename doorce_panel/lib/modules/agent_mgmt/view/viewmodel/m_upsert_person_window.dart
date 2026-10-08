import 'package:doorce_panel/common/types/account_options.dart';
import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/common/utils/m_uri_generator.dart';
import 'package:doorce_panel/common/view_elements/manager_selector.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertPersonWindow {
  final XPerson person;
  final List<XOrganization> _organizationsResources;
  final List<XContactData> _existingContacts;
  late XUserAccount _currentUserAccount;

  late List<String> _availableAccountIds = [];
  late List<XContactData> newContacts = List.empty(growable: true);
  late int newContactsCounter = 0;

  late bool isInsert;

  MUpsertPersonWindow(this.person, this._organizationsResources, this._existingContacts, this._currentUserAccount);

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = person.identifier.isEmpty;
  }

  bool isUserAgentAdmin() {
    return _currentUserAccount.roles.contains(GlobalRole.AgentAdmin);
  }

  // **** Person ****

  // Identifiers
  String createPersonIdentifier(String familyName){
    return MUriGenerator.generateUriFromResource(person, familyName);
  }

  // Roles
  void updateRoles(List<ManagerAssignment> assignments){
    person.rolesInOrganisations = assignments.asMap().map((index, value) 
      => MapEntry(value.agent.identifier, value.roles));
  }

  void updateOrganizationUris(List<ManagerAssignment> assignments){
    person.organisationsUris = assignments.map((e) => e.agent.identifier).toList();
  }

  // Accounts
  AccountOption getAccountOptionInitialValue() {
    if (null != person.userId && person.userId!.isNotEmpty) {
      if (null != person.userPassword || null != person.userEmail) {
        return AccountOption.createAccount;
      }
      return AccountOption.hasAccount;
    }
    
    return AccountOption.noAccount;
  }

  void refreshAvailableAccountIds(List<String> newAccountIds) {
    _availableAccountIds = newAccountIds;
  }

  bool canChangeAccount() {
    return isUserAgentAdmin() || isInsert;
  }

  void resetAllAccountData() {
    person.userId = null;
    person.userPassword = null;
    person.userEmail = null;
  }

  bool validateCreateAccountData() {
    return (null != person.userEmail && person.userEmail!.isNotEmpty) 
      || (null != person.userPassword && person.userPassword!.isNotEmpty);
  }

  // **** Contacts ****

  // Getters
  Set<XContactData> getContactOptions(){
    return {
      ..._existingContacts,
      ...newContacts,
    };
  }

  // Identifiers
  String _createContactIdentifier(int counter){
    return MUriGenerator.generateUriFromContact(person, counter);
  }

  void updateNewContactsIdentifiers(){
    refreshContactsCounter(excludeNewContacts: true);
    newContacts.forEach((contact) {
      contact.identifier = _createContactIdentifier(newContactsCounter++);
      refreshContactsCounter(excludeNewContacts: true, resetCounter: false);
    });
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

  // Delete
  void removeExistingContact(XContactData contact){
    person.contactsUris.removeWhere((c) => c == contact.identifier);
    _existingContacts.remove(contact);
  }

  // Validators
  bool isContactNew(String name, String content) {
    return !newContacts.any((contact) =>
        contact.contents == content &&
        contact.name == name);
  }

  // **** Options for dropdowns ****

  List<String> getAvailableAccountIds() {
    final availableAccountIds = List<String>.from(_availableAccountIds);
    if (person.userId != null && person.userId!.isNotEmpty && !availableAccountIds.contains(person.userId!)) {
      availableAccountIds.add(person.userId!);
    }
    return availableAccountIds;
  }

  List<DropdownItem<String>> getAvailableAccountIdsItems() {
    return getAvailableAccountIds().map((id) {
      return DropdownItem<String>(
        value: id,
        label: id,
        selected: person.userId == id
      );
    }).toList();
  }

  Map<String, List<ManagerRole>> getRoleAssignments() {
    Map<String, List<ManagerRole>> roles = person.rolesInOrganisations;

    if (person.organisationsUris.isEmpty) {
      return roles;
    } else {
      return {
        for (var uri in person.organisationsUris)
          if (roles.keys.contains(uri))
            uri: roles[uri]!
          else
            uri: []
        };
    }
  }

  List<XOrganization> getAvailableOrganizations() {
    return _organizationsResources;
  }

  List<XOrganization> getDisabledOrganizations() {
    if (isUserAgentAdmin()) return [];
    var orgs = _organizationsResources.where((o) => !o.userRoles.contains(ManagerRole.AgentManager)).toList();
    return orgs;
  }

  List<DropdownItem<String>> getOrganizationsOptions() {
    return _organizationsResources.map((organization) {
      return DropdownItem<String>(
        value: organization.identifier,
        label: organization.name,
        selected: person.organisationsUris.contains(organization.identifier)
      );
    }).toList();
  }

  List<DropdownItem<String>> getManagedOrganizationsOptions() {

    Iterable<XOrganization> selectedOrgs = _organizationsResources.where((o) => person.organisationsUris.contains(o.identifier));

    return selectedOrgs.map((org) {
      //final isSelected = person.managedOrganisationsUris.any((p) => p == org.identifier);

        return DropdownItem<String>(
          value: org.identifier,
          label: org.name,
          //selected: isSelected,
        );
      }).toList();
  }
}
