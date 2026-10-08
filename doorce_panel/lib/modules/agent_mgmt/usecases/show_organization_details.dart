import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_organization_details_window.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowOrganizationDetails {
  showOrganizationDetailsSelected(BuildContext context, String query);
  closeSelected(BuildContext context);
}

class UCShowOrganizationDetails with ExceptionHandler implements IUCShowOrganizationDetails {
  final IPOrganizationDetailsWindow _pOrganizationDetailsWindow;
  final AgentManagementAPI _agentManagement;

  const UCShowOrganizationDetails(
      this._pOrganizationDetailsWindow, this._agentManagement);

  @override
  showOrganizationDetailsSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {     
      WaitMessage().show(context);
      List<XPerson> peopleResources = await _agentManagement.getPersonsInOrganisation(identifier);
      List<XContactData> contactDataResources = await _agentManagement.getContactData(identifier);
      XOrganization organizationResource = await _agentManagement.getOrganization(identifier);
      WaitMessage().dismiss();

      _pOrganizationDetailsWindow.show(context, peopleResources, organizationResource, contactDataResources);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pOrganizationDetailsWindow.close(context);
  }
}
