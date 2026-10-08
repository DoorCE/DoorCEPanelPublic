import 'dart:convert';

import 'package:doorce_panel/dtos/access_rights.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/maturity_status.dart';
import 'package:doorce_panel/services/api.dart';

abstract interface class VocabularyManagementAPI {
  Future<List<XAccessRights>> getAccessRights(String languageCode);
  Future<List<MaturityStatus>> getMaturityStatus(String languageCode);

  Future<List<Language>> getLanguages(String locale);
  Future<List<Licence>> getLicences(String locale);
  Future<List<DatasetTheme>> getThemes(String locale);
  Future<List<Frequency>> getFrequencies(String locale);
  Future<List<String>> getFormatMediaTypes(String locale);
  Future<List<String>> getMediaTypes(String type);
}

// NEW CLASS FOR SERVICES
class VocabularyManagement extends Api implements VocabularyManagementAPI {

  VocabularyManagement(super.authAPI);

  @override
  Future<List<XAccessRights>> getAccessRights(String languageCode) async {
    final response = await httpGet('vocabulary/GetAccessRights?languageCode=$languageCode');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        XAccessRights accessRights = XAccessRights();
        accessRights.fromJson(json as Map<String, dynamic>);
        return accessRights;
      }).toList();
    } else {
      throw Exception(
          'Error getting the access rights list with languageCode: $languageCode - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<MaturityStatus>> getMaturityStatus(String languageCode) async {
    final response = await httpGet('vocabulary/GetMaturityStatuses?languageCode=$languageCode');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        MaturityStatus maturityStatus = MaturityStatus();
        maturityStatus.fromJson(json as Map<String, dynamic>);
        return maturityStatus;
      }).toList();
    } else {
      throw Exception(
          'Error getting the maturity status list with languageCode: $languageCode - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Language>> getLanguages(String locale) async {
    final response = await httpGet('vocabulary/GetLanguages?languageCode=$locale');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        return Language.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception(
          'Error fetching languages for locale: $locale - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Licence>> getLicences(String locale) async {
    final response = await httpGet('vocabulary/GetLicences?languageCode=$locale');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        return Licence.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception(
          'Error fetching licences for locale: $locale - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<DatasetTheme>> getThemes(String locale) async {
    final response = await httpGet('vocabulary/GetThemes?languageCode=$locale');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        return DatasetTheme.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception(
          'Error fetching themes for locale: $locale - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Frequency>> getFrequencies(String locale) async {
    final response = await httpGet('vocabulary/GetFrequencies?languageCode=$locale');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((json) {
        return Frequency.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw Exception(
          'Error fetching frequencies for locale: $locale - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getFormatMediaTypes(String code) async {
    final response = await httpGet('vocabulary/GetFormatMediaTypes?code=$code');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((item) => item.toString()).toList();
    } else {
      throw Exception(
          'Error fetching format media types for code: $code - status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<String>> getMediaTypes(String query) async {
    final response = await httpGet('vocabulary/GetMediaTypes?type=$query');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList.map((item) => item.toString()).toList();
    } else {
      throw Exception(
          'Error fetching media types for locale: $query - status code: ${response.statusCode}');
    }
  }
}
