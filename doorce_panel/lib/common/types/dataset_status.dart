import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum DatasetStatus {
  draft, active, deleted, source, independent;

  String getText(BuildContext context, String locale){
    switch (this) {
      case draft: return AppLocalizations.of(context)!.draft;
      case active: return AppLocalizations.of(context)!.active;
      case deleted: return AppLocalizations.of(context)!.deleted;
      case source: return AppLocalizations.of(context)!.source;
      case independent: return AppLocalizations.of(context)!.independent;
    }
  }
}