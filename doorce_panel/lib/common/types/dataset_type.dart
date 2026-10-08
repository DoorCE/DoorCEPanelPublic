import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

enum DatasetType {
  quantitative, qualitative, geospatial, timeSeries, textual, images;

  String getText(BuildContext context, String locale){
    switch (this) {
      case quantitative: return AppLocalizations.of(context)!.quantitative;
      case qualitative: return AppLocalizations.of(context)!.qualitative;
      case geospatial: return AppLocalizations.of(context)!.geospatial;
      case timeSeries: return AppLocalizations.of(context)!.timeSeries;
      case textual: return AppLocalizations.of(context)!.textual;
      case images: return AppLocalizations.of(context)!.images;
    }
  }
}