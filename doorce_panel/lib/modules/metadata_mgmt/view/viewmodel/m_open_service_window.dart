import 'dart:typed_data';

import 'package:doorce_panel/common/types/access_rights_types.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MOpenServiceWindow {
  final List<XDistribution> _servicesContentResources;
  final String _serviceIdentifier;
  final String _servicesTitle;

  MOpenServiceWindow(this._servicesContentResources, this._serviceIdentifier, this._servicesTitle);

  String getServicesTitle() {
    return _servicesTitle;
  }

  String getServiceIdentifier() {
    return _serviceIdentifier;
  }

  int getDistributionResourceListLength() {
    return _servicesContentResources.length;
  }

  String getDistributionResourceTitle(BuildContext context, int index) {
    String locale = Localizations.localeOf(context).languageCode;
    XDistribution resource = _servicesContentResources[index];
    return resource.title[locale] ?? resource.title["en"] ?? resource.title.values.first;
  }

  String getDistributionResourceParams(BuildContext context, int index) {
    XDistribution resource = _servicesContentResources[index];
    String locale = Localizations.localeOf(context).languageCode;
    return "${AppLocalizations.of(context)!.schema}: ${resource.schemaTitle} | ${AppLocalizations.of(context)!.accessStatus}: ${AccessRightTypes.values[resource.accessStatus].getText(context, locale)}";
  }

  String getDistributionResourceDescription(BuildContext context, int index) {
    XDistribution resource = _servicesContentResources[index];
    String locale = Localizations.localeOf(context).languageCode;
    return resource.description[locale] ?? resource.description["en"] ?? resource.description.values.first;
  }

  String getDistributionResourceIdentifier(int index) {
    return _servicesContentResources[index].identifier;
  }

  Uint8List? getDistributionResourceIcon(int index) {
    return _servicesContentResources[index].icon;
  }

  
}
