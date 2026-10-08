import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum GlobalRole {
  AgentAdmin, DataAdmin, SchemaCreator;

  String getText(BuildContext context) {
    switch (this) {
      case AgentAdmin:
        return AppLocalizations.of(context)!.agentAdmin;
      case DataAdmin:
        return AppLocalizations.of(context)!.dataAdmin;
      case SchemaCreator:
        return AppLocalizations.of(context)!.schemaCreator;
    }
  }
}