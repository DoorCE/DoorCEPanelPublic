import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/types/manager_roles.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MAgentManagementWindow {
  late List<XUserAccount> userAccounts;
  late List<XPerson> peopleResources;
  late List<XOrganization> organizationResources;
  late XAgent? _currentAgent;
  late XUserAccount currentUserAccount;
  List<XPerson> _personsForAccounts;

  MAgentManagementWindow(this.userAccounts, this.peopleResources, this.organizationResources, 
    this._currentAgent, this.currentUserAccount, this._personsForAccounts);

  void refreshAgentList(List<XIdentifiableElement> newResourceList) {
    if (newResourceList.first is XPerson) {
      peopleResources = newResourceList as List<XPerson>;
    } else if (newResourceList.first is XOrganization) {
      organizationResources = newResourceList as List<XOrganization>;
    } else {
      throw Exception("Unsupported resource type");
    }
  }

  void refreshUserAccountList(List<XUserAccount> newUserList) {
    userAccounts = newUserList;
  }

  void refreshPersonsForAccounts(List<XPerson> personsForAccounts) {
    _personsForAccounts = personsForAccounts;
  }

  bool isUserAgentAdmin() {
    return currentUserAccount.roles.contains(GlobalRole.AgentAdmin);
  }

  void refreshCurrentUserAccount(XUserAccount user) {
    currentUserAccount = user;
  }

  // -------------------------------------------------------------------------------------------------------- FILTERING --------------------------------------------------------------------------------------------

  ParameterizedListController<T> setController<T>(BuildContext context) {
    return ParameterizedListController<T>(
      querySet: _getQueryset<T>() as List<T>,
      filterSet: getFilterSet<T>(context),
      queryParams: QueryParams(filters: {}));
      // queryParams: state!.getByType<T>() ?? (throw Exception("PageState is null — cannot get query params for type $T")));
  }

  List<Object> _getQueryset<T>() {
    switch (T) {
      case XPerson:
        return peopleResources;
      case XOrganization:
        return organizationResources;
      case XUserAccount:
        return userAccounts;
      default:
        throw Exception("Unsupported resource type");
    }
  }

  FilterSet<T> getFilterSet<T>(BuildContext context) {
    List<FilterDefinition> filters = [];

    switch (T) {
      case XPerson:
        filters = generatePersonFilters(context);
        break;
      case XOrganization:
        filters = generateOrganisationFilters(context);
        break;
      case XUserAccount:
        filters = generateUserFilters(context);
        break;
      default:
        break;
    }

    return FilterSet(filters);
  }

  // -------------------------------------------------------------------------------------------------------- PERSON --------------------------------------------------------------------------------------------

  XPerson getPersonResource(int index) {
    return peopleResources[index];
  }

  int getPeopleResourceListLenght() {
    return peopleResources.length;
  }

  String getPersonIdentifier(int index) {
    return peopleResources[index].identifier;
  }

  String getPersonName(XPerson resource) {
    String fullName = "${resource.givenNames.firstOrNull ?? ""} ${resource.familyName}";
    return fullName;
  }

  List<String> getPersonOrganizations(XPerson resource){
    return resource.organisationsNames.values.toList();
  }

  bool isPersonEditableAndDeletable(XPerson person) {
    if (_currentAgent?.identifier == person.identifier) {
      return true;
    } else if (person.organisationsUris.isNotEmpty) {
      return person.userRoles.contains(ManagerRole.AgentManager);
    } else {
      return isUserAgentAdmin();
    }
  }

  List<FilterDefinition> generatePersonFilters(BuildContext context) {
    List<FilterOption> orgOptions = organizationResources.map((o) 
          => FilterOption(
            label: o.name, 
            value: o.identifier)).toList();

        return [
          EnumFilter<XPerson, String>(
            fieldName: "organisationUris", 
            label: AppLocalizations.of(context)!.organisations, 
            filterOptions: orgOptions, 
            filterTarget: (XPerson item) => item.organisationsUris,
            modeOptionsEnabled: true
            ),
          BoolFilter<XPerson, bool>(
            fieldName: "userRoles", 
            label: AppLocalizations.of(context)!.editableByMe, 
            filterTarget: (XPerson item) => isPersonEditableAndDeletable(item)
          ),
        ];
  }

  //----------------------------------------------------------------------------------------------------------- USER --------------------------------------------------------------------------------------------
  int getUserAccountListLength() {
    return userAccounts.length;
  }

  XUserAccount getUserAccount(int index) {
    return userAccounts[index];
  }

  List<String> getUsersAgentIds() {
    List<String> agentIds = [];
    for (XUserAccount user in userAccounts) {
      if (user.personUri != null && user.personUri!.isNotEmpty) {
        agentIds.add(user.personUri!);
      }
    }
    return agentIds;
  }

  bool areAgentsDuplicated(String? selectedAgentId) {
    List<String> agentIds = getUsersAgentIds();

    // Track seen items and duplicates
    Set<String> seen = {};
    Set<String> duplicates = {};

    for (var item in agentIds) {
      if (!seen.add(item) && item.isNotEmpty) {
        duplicates.add(item);
      }
    }
    return duplicates.contains(selectedAgentId);
  }

  void assignAgentToUser(XUserAccount user, String? personUri) {
    if (personUri != null && personUri.isNotEmpty) {
      user.personUri = personUri;
    } else {
      user.personUri = null;
    }
  }

  List<XPerson> getAllowedPersonsForAccount(XUserAccount userAccount) {
    List<XPerson> allowedPersons = List.from(_personsForAccounts);
    allowedPersons.addAll(peopleResources.where((p) => p.identifier == userAccount.personUri));
    //allowedPersons.removeWhere((person) => getUsersAgentIds().contains(person.identifier) && person.identifier != userAccount.personUri);
    return allowedPersons;
  }

  List<String> getAllowedPersonsForAccountIds(XUserAccount userAccount) {
    return getAllowedPersonsForAccount(userAccount).map((person) => person.identifier).toList();
  }

  List<DropdownItem<String>> getAllowedPersonsForAccountItems(XUserAccount userAccount) {
    List<XPerson> allowedPersons = getAllowedPersonsForAccount(userAccount);
    
    return allowedPersons.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.firstOrNull ?? ""} ${person.familyName}",
        selected: userAccount.personUri == person.identifier
      );
    }).toList();
  }

  List<FilterDefinition> generateUserFilters(BuildContext context) {
    List<FilterOption> roleOptions = GlobalRole.values.map((v)
          => FilterOption(
            label: v.getText(context),
            value: v.index)).toList();

        return [
          EnumFilter<XUserAccount, int>(
            fieldName: "roles", 
            label: AppLocalizations.of(context)!.roles, 
            filterOptions: roleOptions, 
            filterTarget: (XUserAccount item) => item.roles.map((r) => r.index).toList(),
            modeOptionsEnabled: true
            ),
        ];
  }

// -------------------------------------------------------------------------------------------------------- ORGANIZATION --------------------------------------------------------------------------------------------

  int getOrganizationResourceListLength() {
    return organizationResources.length;
  }

  XOrganization getOrganizationResource(int index) {
    return organizationResources[index];
  }

  String getOrganizationIdentifier(int index) {
    return organizationResources[index].identifier;
  }

  String getOrganizationMembersCount(XOrganization org) {
    return "${org.membersUris.length}";
  }

  bool isOrganizationEditable(XOrganization item) {
    return item.userRoles.contains(ManagerRole.AgentManager) 
      || item.userRoles.contains(ManagerRole.MetadataManager);
  }

  bool isOrganizationDeletable(XOrganization item) {
    return isUserAgentAdmin();
  }

  List<FilterDefinition> generateOrganisationFilters(BuildContext context) {
    List<FilterOption> memberOptions = peopleResources.map((o) 
          => FilterOption(
            label: o.fullName, 
            value: o.identifier)).toList();

        return [
          EnumFilter<XOrganization, String>(
            fieldName: "membersUris", 
            label: AppLocalizations.of(context)!.members, 
            filterOptions: memberOptions, 
            filterTarget: (XOrganization item) => item.membersUris,
            modeOptionsEnabled: true
            ),
          BoolFilter<XOrganization, bool>(
            fieldName: "userRoles", 
            label: AppLocalizations.of(context)!.editableByMe, 
            filterTarget: (XOrganization item) => isOrganizationEditable(item)
          ),
        ];
  }
}
