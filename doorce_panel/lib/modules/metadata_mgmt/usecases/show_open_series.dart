import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_open_series_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowOpenSeries {
  closeSelected(BuildContext context);
  showSeriesContentSelected(BuildContext context, String identifier);
}

class UCShowOpenSeries with ExceptionHandler implements IUCShowOpenSeries {
  final IPOpenSeriesWindow _pSeriesContentsWindow;
  final DatasetManagementAPI _datasetManagement;
  final AgentManagementAPI _agentManagement;

  const UCShowOpenSeries(
      this._pSeriesContentsWindow, this._datasetManagement, this._agentManagement);

  @override
  closeSelected(BuildContext context) {
    _pSeriesContentsWindow.close(context);
  }
  
  @override
  showSeriesContentSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XDatasetSeries series = await _datasetManagement.getSeries(identifier);
      List<XDataset> seriesContentResources = await _datasetManagement.getSeriesDatasetList(identifier);
      List<XPerson> persons = await _agentManagement.getPersons("");
      List<XOrganization> organizations = await _agentManagement.getOrganizations("");
      WaitMessage().dismiss();
      
      _pSeriesContentsWindow.show(context, seriesContentResources, series, persons, organizations);
    });
  }
}
