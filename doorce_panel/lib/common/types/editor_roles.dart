import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum EditorRole {
  DistributionEditor, MetadataEditor, OwnershipEditor;

  String getText(BuildContext context) {
    switch (this) {
      case DistributionEditor:
        return AppLocalizations.of(context)!.distributionEditor;
      case MetadataEditor:
        return AppLocalizations.of(context)!.metadataEditor;
      case OwnershipEditor:
        return AppLocalizations.of(context)!.ownershipEditor;
    }
  }

}