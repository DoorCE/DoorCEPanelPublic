import 'dart:convert';

import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/services/api.dart';
import 'package:doorce_panel/services/auth_api.dart';
import 'package:http/http.dart' as http;

abstract interface class AgentManagementAPI {
  Future<bool> checkAgentId(String identifier);
  Future<XPerson> getPerson(String identifier);
  Future<List<XContactData>> getContactData(String identifier);
  Future<List<XContactData>> getResourceContactData(String identifier);
  Future<List<String>> getAvailableAccountIds(String query);
  Future<XAgent?> getCurrentAgent();
  Future<XUserAccount> getCurrentUserAccount();
  Future<List<XUserAccount>> getUserAccounts();
  Future<XOrganization> getOrganization(String identifier);
  Future<List<XPerson>> getPersons(String query);
  Future<List<XPerson>> getPersonsInOrganisation(String query);
  Future<List<XOrganization>> getOrganizations(String query);
  Future<List<XOrganization>> getAllowedOrganizations(String? personUid);
  Future<http.Response> upsertPerson(XPerson person, List<XContactData> newContacts);
  Future<http.Response> upsertOrganization(XOrganization organization, List<XContactData> newContacts);
  Future<http.Response> deleteAgent(String identifier);
  Future<http.Response> deleteUserAccount(String accountId);
  Future<http.Response> upsertUserAccount(XUserAccount user);
  Future<List<XPerson>> getAllowedPersonsForAccounts(String? accountId);
}

class AgentManagement extends Api implements AgentManagementAPI {

  AgentManagement(AuthAPI authAPI) : super(authAPI);

  @override
  Future<bool> checkAgentId(String identifier) async {
    final response = await httpGet('agents/CheckAgentId?identifier=$identifier');

    if (response.statusCode == 200) {
      bool result = jsonDecode(response.body);
      return result;
    } else {
        throw Exception(
          'Error checking uniqueness of the identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XOrganization>> getAllowedOrganizations(String? personUid) async {
    final response = await httpGet('agents/GetAllowedOrganisations${null!=personUid ? "?personUid=$personUid" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XOrganization organization = XOrganization();
        organization.fromJson(json as Map<String, dynamic>);
        return organization;
      }).toList();
    } else {
      throw Exception(
          'Error getting organizations with query: $personUid - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getAvailableAccountIds(String query) async {
    if (3 > query.length) return [];
    final response = await httpGet('agents/GetAvailableAccountIds?query=$query');

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.cast<String>();
    } else if (response.statusCode == 400) {
      return [];
    } else {
      throw Exception(
          "Failed to fetch available account ids - status code: ${response.statusCode}");
    }
  }

  @override
  Future<XAgent?> getCurrentAgent() async {
    final response = await httpGet('agents/GetAgent');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final person = XAgent();
      person.fromJson(jsonResponse);
      return person;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
          "Failed to fetch current user - status code: ${response.statusCode}");
    }
  }

  @override
  Future<XUserAccount> getCurrentUserAccount() async {
    final response = await httpGet('agents/GetUserAccount');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final account = XUserAccount();
      account.fromJson(jsonResponse);
      return account;
    } else {
      throw Exception(
          "Failed to fetch current user - status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<XUserAccount>> getUserAccounts() async {
    final response = await httpGet('agents/GetUserAccountList');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XUserAccount userAccount = XUserAccount();
        userAccount.fromJson(json as Map<String, dynamic>);
        return userAccount;
      }).toList();
    } else {
      throw Exception(
          'Error getting user accounts - status code: ${response.statusCode}');
    }
  }

  @override
  Future<XPerson> getPerson(String identifier) async {
    final response = await httpGet('agents/GetAgent?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final person = XPerson();
      person.fromJson(jsonResponse);
      return person;
    } else {
      throw Exception(
          "Failed to fetch person with identifier: $identifier - status code: ${response.statusCode}");
    }
  }

  @override
  Future<XOrganization> getOrganization(String identifier) async {
    final response = await httpGet('agents/GetAgent?identifier=$identifier');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final organization = XOrganization();
      organization.fromJson(jsonResponse);
      return organization;
    } else {
      throw Exception(
          "Failed to fetch organization with identifier: $identifier - status code: ${response.statusCode}");
    }
  }

  @override
  Future<List<XOrganization>> getOrganizations(String query) async {
    final response = await httpGet('agents/GetOrganisationList?query=$query');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XOrganization organization = XOrganization();
        organization.fromJson(json as Map<String, dynamic>);
        return organization;
      }).toList();
    } else {
      throw Exception(
          'Error getting organizations with query: $query - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XPerson>> getPersons(String query) async {
    final response = await httpGet('agents/GetPersonList?query=$query');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XPerson person = XPerson();
        person.fromJson(json as Map<String, dynamic>);
        return person;
      }).toList();
    } else {
      throw Exception(
          'Error getting persons with query: $query - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XPerson>> getPersonsInOrganisation(String identifier) async {
    final response = await httpGet('agents/GetPersonsInOrganisation?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XPerson person = XPerson();
        person.fromJson(json as Map<String, dynamic>);
        return person;
      }).toList();
    } else {
      throw Exception(
          'Error getting persons with query: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> upsertPerson(XPerson person, List<XContactData> newContacts) async {
    final body = jsonEncode({
      'person': person.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('agents/UpsertPerson', body);
    return response;
  }

  @override
  Future<http.Response> upsertOrganization(XOrganization organization, List<XContactData> newContacts) async {
    final body = jsonEncode({
      'organisation': organization.toJson(),
      'newContacts': newContacts.map((contact) => contact.toJson()).toList(),
    });

    final response = await httpPost('agents/UpsertOrganisation', body);

    return response;
  }

  @override
  Future<List<XContactData>> getContactData(String identifier) async {
    final response = await httpGet('agents/GetAgentContacts?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        final contactData = XContactData();
        contactData.fromJson(json as Map<String, dynamic>);
        return contactData;
      }).toList();
    } else {
      throw Exception(
          'Error getting contact data for identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<XContactData>> getResourceContactData(String identifier) async {
    final response = await httpGet('agents/GetResourceContacts?identifier=$identifier');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        final contactData = XContactData();
        contactData.fromJson(json as Map<String, dynamic>);
        return contactData;
      }).toList();
    } else {
      throw Exception(
          'Error getting contact data for identifier: $identifier - status code: ${response.statusCode}');
    }
  }

  @override
  Future<http.Response> deleteAgent(String identifier) async {
    final response = await httpDelete('agents/DeleteAgent?identifier=$identifier');
    return response;
  }

  @override
  Future<http.Response> deleteUserAccount(String accountId) async {
    final response = await httpDelete('agents/DeleteUserAccount?accountId=$accountId');
    return response;
  }

  @override
  Future<http.Response> upsertUserAccount(XUserAccount user) async {
    final body = jsonEncode(user.toJson());
    final response = await httpPost('agents/UpsertUserAccount', body);
    return response;
  }

  @override
  Future<List<XPerson>> getAllowedPersonsForAccounts(String? accountId) async {
    final response = await httpGet('agents/GetAllowedPersonsForAccount${null != accountId ? "?accountId=$accountId" : ""}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XPerson person = XPerson();
        person.fromJson(json as Map<String, dynamic>);
        return person;
      }).toList();
    } else {
      throw Exception(
          'Error getting persons for account: $accountId - status code: ${response.statusCode}');
    }
  }
}