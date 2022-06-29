import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showdialog(context, text, func) {
  // ignore: avoid_single_cascade_in_expression_statements
  AwesomeDialog(
    context: context,
    dismissOnTouchOutside: false,
    animType: AnimType.SCALE,
    dialogType: DialogType.SUCCES,
    body: Center(
      child: Text(
        text,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),
    ),
    title: 'This is Ignored',
    desc: 'This is also Ignored',
    btnOkOnPress: func,
  )..show();
}
