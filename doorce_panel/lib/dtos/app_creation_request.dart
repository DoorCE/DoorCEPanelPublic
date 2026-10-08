import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/source_creation_request.dart';

class XAppCreationRequest extends XApp {
  final List<XSourceCreationRequest> newResources = List.empty(growable: true);
  final String? sourceCatalogueUri = null;

  XAppCreationRequest();

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'newResources': newResources.map((r) => r.toJson()).toList(),
      'sourceCatalogueUri': sourceCatalogueUri,
    };
  }
}