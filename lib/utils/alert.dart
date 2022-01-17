
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';




alert(BuildContext context, String msg, {Function? callback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Fidelizze"),
          content: Text("$msg"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (callback != null) {
                  callback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}

alertConfirm(BuildContext context, String msg, { Function? confirmCallback}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Fidelizze"),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Confirmar"),
              onPressed: () {
                Navigator.pop(context);
                if (confirmCallback != null) {
                  confirmCallback();
                }
              },
            )
          ],
        ),
      );
    },
  );
}


void toast(BuildContext context,String msg, { int? duration,  int? gravity}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );
}