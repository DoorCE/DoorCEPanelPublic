import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/data_resource.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_data_management_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';

enum ResourceType {
  datasets,
  series,
}

abstract interface class IUCShowDataManagement {
  showDataManagementSelected(BuildContext context);
  closeSelected(BuildContext context);
}

class UCShowDataManagement with ExceptionHandler implements IUCShowDataManagement {
  final IPDataManagementWindow _pDataManagementWindow;
  final DatasetManagementAPI _datasetManagement;
  final AgentManagementAPI _agentManagement;

  const UCShowDataManagement(
      this._pDataManagementWindow, this._datasetManagement, this._agentManagement);

  @override
  showDataManagementSelected(BuildContext context) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      List<XDataResource> resources =
          await _datasetManagement.getManagedDataResources(null);
      List<XDataset> datasets = resources.where((e) => e is XDataset).toList().cast<XDataset>();
      List<XDatasetSeries> series = resources.where((e) => e is XDatasetSeries).toList().cast<XDatasetSeries>();

      List<XPerson> persons = await _agentManagement.getPersons("");
      List<XOrganization> organisations = await _agentManagement.getOrganizations("");
      WaitMessage().dismiss();

      _pDataManagementWindow.show(context, datasets, series, persons, organisations);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pDataManagementWindow.close(context);
  }
}
