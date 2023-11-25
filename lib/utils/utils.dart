import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class utils {


  static void fieldFocus(BuildContext context,FocusNode currentNode,FocusNode nextNode)
  {
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextNode);
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
