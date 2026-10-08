import 'package:doorce_panel/modules/main_panel/view/main_panel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/router_service.dart';

abstract class AbstractPresenter {

  final String routingNamePrefix;

  String getRoutingName() => routingNamePrefix;

  const AbstractPresenter(this.routingNamePrefix);

  pushWindow(BuildContext context, String iconUri, String titleText,
      bool isMainMenu, Widget body, [notAuthenticated = false]) {
    
    context.read<RouterService>().push(getRoutingName(), context
        .read<VMainPanelFactory>()
        .get(context, iconUri, titleText, isMainMenu, body, notAuthenticated));
  }

  popWindow(BuildContext context) => context.read<RouterService>().pop();
}
