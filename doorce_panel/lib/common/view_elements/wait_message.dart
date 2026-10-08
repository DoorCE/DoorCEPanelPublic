import 'package:doorce_panel/navigation/app_router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

class WaitMessage {
  static final WaitMessage _singleton = WaitMessage._internal();
  AppRouterDelegate? _delegate;
  bool isDisplayed = false;

  factory WaitMessage() {
    return _singleton;
  }

  WaitMessage._internal();

  show(BuildContext context) {
    if(isDisplayed) {
      return;
    }
    _delegate = context.read<AppRouterDelegate>();
    final dialogContext = _delegate?.navigatorKey.currentContext ?? context;
    String text = AppLocalizations.of(context)!.loading;
    isDisplayed = true;
    showDialog<void>(
        context: dialogContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          
          return PopScope(
            canPop: false,
            child: SimpleDialog(
              backgroundColor: Colors.white,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(text),
                      )
                    ],
                  ),
                )
              ] ,
            ),
          );
        }
    );
  }

  dismiss() {
    Logger.root.info("WaitMessage dismiss called (isDisplayed: $isDisplayed)");
    if(isDisplayed) {
      _delegate?.forcePopRoute();
      isDisplayed = false;
      _delegate = null;
    }
  }
}