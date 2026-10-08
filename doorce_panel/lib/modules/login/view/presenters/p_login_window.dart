import 'package:doorce_panel/modules/login/view/login_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract interface class IPLoginWindow {
  show(BuildContext context);
}

class PLoginWindow implements IPLoginWindow {
  const PLoginWindow();

  @override
  show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => context.read<VLoginWindowFactory>().get(context)),
    );
  }
}

