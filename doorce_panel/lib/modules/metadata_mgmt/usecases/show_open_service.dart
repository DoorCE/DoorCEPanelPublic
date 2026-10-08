import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_open_service_window.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowOpenService {
  closeSelected(BuildContext context);
  showServicesContentSelected(BuildContext context, String identifier);
}

class UCShowOpenService with ExceptionHandler implements IUCShowOpenService {
  final IPOpenServiceWindow _pServicesContentsWindow;
  final DatasetManagementAPI _datasetManagement;

  const UCShowOpenService(
      this._pServicesContentsWindow, this._datasetManagement);
  @override
  closeSelected(BuildContext context) {
    _pServicesContentsWindow.close(context);
  }
  
  @override
  showServicesContentSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XDistribution> servicesContentResources = await _datasetManagement.getServicesContents(identifier);
      XDatasetService service = await _datasetManagement.getDataService(identifier);
      String locale = Localizations.localeOf(context).languageCode;
      String serviceTitle = service.title[locale] ?? service.title["en"] ?? service.title.values.first;
      String serviceIdentifier = service.identifier;
      WaitMessage().dismiss();
      
      _pServicesContentsWindow.show(context, servicesContentResources, serviceIdentifier, serviceTitle);
    });

  }
}
