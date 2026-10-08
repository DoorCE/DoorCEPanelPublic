import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:flutter/material.dart';

class SnackMessage {
  static final SnackMessage _singleton = SnackMessage._internal();
  
  factory SnackMessage() {
    return _singleton;
  }

  SnackMessage._internal();

  show(BuildContext context, bool isError, {String text = '...'}) {
    SnackBar snackBar = SnackBar(
      content: Text(text),
      backgroundColor: isError ? DoorColor.red : DoorColor.greyBlur,
      duration: Duration(milliseconds: isError ? 12000 : 3000),
      width: 280.0, // Width of the SnackBar.
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    );
    // Find the ScaffoldMessenger in the widget tree and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}