import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum AccessStatus {
  available, unavailable, defective;

  String getText(BuildContext context, String locale){
    switch (this) {
      case AccessStatus.available: return AppLocalizations.of(context)!.available;
      case AccessStatus.unavailable: return AppLocalizations.of(context)!.unavailable;
      case AccessStatus.defective: return AppLocalizations.of(context)!.defective;
    }
  }
}