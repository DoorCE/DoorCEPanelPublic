import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum ManagerRole {
  AgentManager, DistributionManager, MetadataManager, OwnershipManager;

  String getText(BuildContext context) {
    switch (this) {
      case AgentManager:
        return AppLocalizations.of(context)!.agentManager;
      case MetadataManager:
        return AppLocalizations.of(context)!.metadataManager;
      case DistributionManager:
        return AppLocalizations.of(context)!.distributionManager;
      case OwnershipManager:
        return AppLocalizations.of(context)!.ownershipManager;
    }
  }
}