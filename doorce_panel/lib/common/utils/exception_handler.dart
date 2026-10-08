import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

mixin ExceptionHandler {
  Future<void> tryForApiExceptions(BuildContext context, Future<void> Function() action) async {
    try {
      await action();
    } on AuthenticationException {
      WaitMessage().dismiss();
      SnackMessage().show(context, true, text: AppLocalizations.of(context)!.reloginRequired);
      context.read<IUCStart>().startSelected(context);
    } catch (e, stack) {
      WaitMessage().dismiss();
      SnackMessage().show(context, true, text: 'Error: $e');
      //TODO: dedicated error pages
      context.read<IUCStart>().startSelected(context);
      Logger.root.severe(e);
      Logger.root.severe(stack);
    }
  }
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}