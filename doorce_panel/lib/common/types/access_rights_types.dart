import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum AccessRightTypes {
  public, confidential, nonPublic, restricted, sensitive, provisional;

  String getText(BuildContext context, String locale){
    switch (this) {
      case AccessRightTypes.public: return AppLocalizations.of(context)!.public;
      case AccessRightTypes.confidential: return AppLocalizations.of(context)!.confidential;
      case AccessRightTypes.nonPublic: return AppLocalizations.of(context)!.nonPublic;
      case AccessRightTypes.restricted: return AppLocalizations.of(context)!.restricted;
      case AccessRightTypes.sensitive: return AppLocalizations.of(context)!.sensitive;
      case AccessRightTypes.provisional: return AppLocalizations.of(context)!.provisional;
    }
  }
}