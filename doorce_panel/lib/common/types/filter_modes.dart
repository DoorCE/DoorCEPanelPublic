import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum EnumFilterMode {
  and, or;

  String getText(BuildContext context) {
    switch (this) {
      case and: return AppLocalizations.of(context)!.and;
      case or: return AppLocalizations.of(context)!.or;
    }
  }
}