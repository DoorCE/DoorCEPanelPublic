import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum AppStatus {
  Created, InProcessing, Ready, HasErrors;

  String getText(BuildContext context) {
    switch (this) {
      case Created:
        return AppLocalizations.of(context)!.created;
      case InProcessing:
        return AppLocalizations.of(context)!.inProcessing;
      case Ready:
        return AppLocalizations.of(context)!.ready;
      case HasErrors:
        return AppLocalizations.of(context)!.hasErrors;
    }
  }
}