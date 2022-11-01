import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils {
  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed, {
    bool isConfirmationDialog = false,
    String buttonText2 = "",
    Function? onPressed2,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              MaterialButton(
                  onPressed: () {
                    return onPressed();
                  },
                  child: Text(buttonText)),
              Visibility(
                  visible: isConfirmationDialog,
                  child: MaterialButton(
                    child: Text(buttonText2),
                    onPressed: () {
                      if (onPressed2 != null) {
                        onPressed2();
                      }
                    },
                  ))
            ],
          );
        });
  }
}


