import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/ownable_resource.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/schema_series.dart';

class MUriGenerator {

  static String _getResourcePrefix(XIdentifiableElement element) {
    switch (element.runtimeType) {
      case XDataset: return "dat";
      case XDatasetSeries: return "ser";
      case XDatasetService: return "srv";
      case XDistribution: return "dis";
      case XCatalogue: return "cat";
      case XPerson: return "prs";
      case XOrganization: return "org";
      case XDataSchema: return "dsh";
      case XSchemaSeries: return "shs";
      case XApp: return "app";
      case XAppTemplate: return "apt";
      default: throw Exception("Unknown resource type");
    }
  }

  static String generateUriFromContact(XIdentifiableElement owner, int counter){
    return generateIdentifier("cnt", owner.identifier, counter.toString());
  }

  static String generateUriFromResource(XIdentifiableElement element, String? title){
    String prefix = _getResourcePrefix(element);
    String? version = element is XDataset ? element.version : null;
    String idTitle;
    if (element is XOwnableResource) {
        idTitle = ((element.title.isEmpty ||
          element.title.values.every((title) => title.isEmpty)) ? title 
            : element.title["en"]
                ?? element.title.values.firstOrNull)
                ?? "";
    } else if (element is XSchemaSeries) {
      idTitle = element.title;
    } else if (element is XDataSchema) {
      idTitle = element.title;
    } else if (element is XApp) {
      idTitle = element.title;
    } else if (element is XAppTemplate) {
      idTitle = element.title;
    } else if (element is XOrganization) {
      idTitle = element.name;
    } else if (element is XPerson) {
      idTitle = element.familyName;
    } else if (element is XDistribution) {
      idTitle = ((element.title.isEmpty ||
          element.title.values.every((title) => title.isEmpty)) ? title 
            : element.title["en"]
                ?? element.title.values.firstOrNull)
                ?? "";
    } else {
      throw Exception("Unknown resource abstract type");
    }
    return generateIdentifier(prefix, idTitle, version);
  }

  static String generateIdentifier(String prefix, String title, String? suffix){
    String idTitle = title.trim().toLowerCase().replaceAll(RegExp(r"[^a-zA-Z0-9]+"), "_");
    return '$prefix/$idTitle' + (null == suffix ? "" : '/${suffix}');
  }
}