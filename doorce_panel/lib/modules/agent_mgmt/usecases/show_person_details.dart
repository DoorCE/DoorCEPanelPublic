import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/presenters/p_person_details_window.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowPersonDetails {
  showPersonDetailsSelected(BuildContext context, String query);
  closeSelected(BuildContext context);
}

class UCShowPersonDetails with ExceptionHandler implements IUCShowPersonDetails {
  final IPPersonDetailsWindow _pPersonDetailsWindow;
  final AgentManagementAPI _agentManagement;

  const UCShowPersonDetails(this._pPersonDetailsWindow, this._agentManagement);

  @override
  closeSelected(BuildContext context) {
    _pPersonDetailsWindow.close(context);
  }

  @override
  showPersonDetailsSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      XPerson personResource = await _agentManagement.getPerson(identifier);
      List<XContactData> contactDataResources =
          await _agentManagement.getContactData(identifier);
      WaitMessage().dismiss();

      _pPersonDetailsWindow.show(context, personResource, contactDataResources);
    });
  }
}
